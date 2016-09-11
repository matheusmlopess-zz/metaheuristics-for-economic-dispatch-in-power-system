function [matriz_orig_interface_sp,matriz_orig_interface_cp, matriz_melhor_ger,matriz_pop_pop_interface,matriz_custo_sp_interface,matriz_custo_cp_interface,matriz_custo_cplimites_interface,matriz_melhor_interface,matriz_customelhor_interface,matriz_custoietr_interface,matriz_sigma_iter_interface,num_iter,evo_geracaoG11,evo_geracaoG12,evo_geracaoG41,evo_geracaoG42]=corpo(pop_ini,Factor_aprendiz,sigma_0,n_iter,carga_0)
format shortG
fprintf('-------------------------------LER DADOS----------------------------------------------\n')
fprintf('---------------------------Caracteristicas da Geradores-------------------------------\n ')
fprintf('         doB1       paraB2        R             X      Limite_linhas \n')
s=[[1 2 0.03 0.08 75];[1 5 0.09 0.32 102];[2 3 0.05 0.08 45];[2 5 0.05 0.16 100];[3 4 0.04 0.10 90];[4 5 0.04 0.10 87]];
disp(s)
%                       Classificão dos barramentos da Rede
%-------------------------------------------------------------------------------------- 
    
    format shortG
   %Fromação da Matriz de Susceptâcia [B]
    Geradoresinfo = s;
    DE_B = Geradoresinfo(:,1);       % Vetor de barramentos de origem...
    PARA_B = Geradoresinfo(:,2);     % Vetor de barramentos de destino...
    r = Geradoresinfo(:,3);          % Vetor de Resistencias, R...
    x = Geradoresinfo(:,4);          % Vetor de Rtancias, X...
    lim_linhas = Geradoresinfo(:,5);          % Vetor de Adimitancia de terra, B/2...
    z = x;                           % Z (matriz)...
    y = 1./z;                        % inverte os elementos de Z...
    nbarramento = max(max(DE_B),max(PARA_B));            % no. de barramentos...
    n_no = length(DE_B);                                 % no. nós...
    ybarramento = zeros(nbarramento,nbarramento);        % inicializa o ybarramento...
  % Fomação do triangulo inferior e superior da matriz de susceptância ...
for k=1:n_no
     ybarramento(DE_B(k),PARA_B(k)) = -y(k);                                %analiza posição dos vectores nos barramentos
     ybarramento(PARA_B(k),DE_B(k)) = ybarramento(DE_B(k),PARA_B(k));       %preenche o valor anterior na posição simetrica da matriz
end
% Formação da diagonal principal...
 for m=1:nbarramento
     for n=1:n_no
         if DE_B(n) == m || PARA_B(n) == m
             ybarramento(m,m) = ybarramento(m,m) + y(n);
         end
     end
 end
 
 
fprintf('                           Matriz inversa [B] - Impedâncias   \n')
    %   
    m = ybarramento(~ismember(1:size(ybarramento, 1), [1,0]), :);
    fprintf('Eliminando Geradores e coluna do barramento de referencia da matriz [B] obtemos  \n')

    %Eliminando Geradores e coluna do barramento de referencia da matriz [B] obtemos
	ybarramento(:, 1)=[];
	m = ybarramento(~ismember(1:size(ybarramento, 1), 1), :);
    disp(m)
	fprintf('invertendo [B] obtemos [B]^-1 =  \n')
    %      
	m=inv(m);
    disp(m)
fprintf('Limites dos geradores e Custos associados  \n')
fprintf('         Lim_inf       Lim_sup        a           b           c \n')

Ger=[ 
     30 90 800 20 0.06
     20 60 800 16 0.10
     40 80 800 20 0.08
     30 70 800 22 0.11];
 disp(Ger)

Geradores_aux=[1 1; 1 2; 4 1; 4 2];
linhas_aux=[1 1; 1 5; 2 3; 2 5; 3 4; 4 5];
fprintf('Limites das Linhas  \n')
fprintf('D_Brr  P_Brr  Limit(MVA)  \n')
linhas_aux =[linhas_aux lim_linhas];
disp(linhas_aux)
lim_Geradores = Ger(:,1);     % Prenche matriz de intervalos para valore minimos 
lim_Geradores(:,2) = Ger(:,2);     % Prenche matriz  de intervalos para valore maximos 
bar_gerr=[1 1; 1 2; 4 1; 4 2];
aux=[bar_gerr Ger];


%VARIAVEIS INICIAIS DO SISTEMA
  
carga=carga_0;
u=pop_ini;
FtrAprend=Factor_aprendiz;
cnt=0;
M1=1000; 
M2=1000;

%-----------------------FORMAÇÃO DA POPOULAÇÃO ORIGINAL--------------------
for i=1:1:4
matriz_orig(i,:)=  lim_Geradores(i,1)+(lim_Geradores(i,2)-lim_Geradores(i,1))*rand(u,1); %formaï¿½ï¿½o da matriz com valores aleatorios de geraçao original
end

%CORREÇÃO DA GERAÇÃO (Pg=Pc)
for i=1:1:u  %corrige as geraï¿½ï¿½es em funï¿½ï¿½o da carga exigida
      Ger_total(1,i) = sum(matriz_orig(:,i));
      matriz_orig(:,i)= matriz_orig(:,i)*(carga/Ger_total(1,i));
     
end

[Geradores,Pop]=size(matriz_orig);
%calculo do custo sem penalizações de cada coluna
 matriz_orig(5,:)=matriz_orig(4,:);
 matriz_orig(5,:)=0;

 
   for k=1:1:Pop
        for i=1:1:Geradores
              aux(i,k)=Ger(i,3)+Ger(i,4)*matriz_orig(i,k)+Ger(i,5)*power(matriz_orig(i,k),2);
              if i==4 
              matriz_orig(5,k)=sum(aux(:,k));
              end
        end
   end
   matriz_orig_interface_sp=matriz_orig;
   
% calculo dos custos com penalização da matriz Pop original
custo_pen=matriz_orig(5,:);
custo_pen2=matriz_orig(5,:);
custo_pen2(1,:)=0;
    for j=1:1:Pop
      for i = 1:1:Geradores
        if (matriz_orig(i,j) > lim_Geradores(i,2))
            custo_pen(1,j)=matriz_orig(5,j)+M1*(matriz_orig(i,j)-lim_Geradores(i,2));
            custo_pen2(1,j)=matriz_orig(5,j)+M1*(matriz_orig(i,j)-lim_Geradores(i,2));   
        end
            if (matriz_orig(i,j)<lim_Geradores(i,1))
            custo_pen(1,j)=matriz_orig(5,j)+M2*(lim_Geradores(i,1)-matriz_orig(i,j));
            custo_pen2(1,j)=matriz_orig(5,j)+M2*(lim_Geradores(i,1)-matriz_orig(i,j));
            end
        end
    end
   matriz_orig(5,:)=custo_pen;
   matriz_orig_interface_cp=matriz_orig;
%---INICIALIZA CICLO DO ALGORITIMO DE PROGRAMAÇÃO EVOLUCIONARIA EVOLUÇAO---
clone = matriz_orig;
clone(5,:)=0;
aux_excesso=0; 
ii=1; 

iter=n_iter;
sig = matriz_orig(5,:);
sig(1,:)=sigma_0;

%---INICIALIZA CICLO DO ALGORITIMO DE PROGRAMAÇÃO EVOLUCIONARIA EVOLUÇAO---

while(ii~=iter)
%----------------------------- CLONAR--------------------------------------
    for j = 1:1:Pop
        sig(1,Pop+j)=sig(1,j);             %duplica sigma
        custo_pen(1,Pop+j)=custo_pen(1,j); %duplica vetor custo para caso de penalização
    end
    
    if ii>1
       clone=matriz_orig;         %para iteações superiores a primeira clone
       clone(5,:)=0;              %recebe matriz população gerada na ultima iteração
    end
  
    matriz_concat = [matriz_orig clone]; %criação da nova matriz População + Clone
   
    matriz_melhor_ger=clone;
    matriz_pop_pop_interface=matriz_concat;
%------------------------------- MUTAR ------------------------------------
     %mutaçao do sigma - método auto-adaptativo
     for k=(Pop+1):1:Pop+Pop
            sig(1,k)=sig(1,k)*(1+FtrAprend*norminv(rand,0,1)); %determina um valor sigma para cada Clone
         for i=1:1:Geradores
            %Efetua mutação com o valor acima atribuido 
            matriz_concat(i,k)=matriz_concat(i,k)+sig(1,k)*norminv(rand,0,1);
         end
     end
   
 %CORREÇÃO DA GERAÇÃO (Pg=Pc)
Ger_total=matriz_concat(1,:); %inicializa variavel utulizada para calcular as geraçoes
Ger_total(1,:)=0;             %seta para zero

for i=(Pop+1):1:(Pop+Pop)  %corrige as geraçoes em função da carga exigida
      Ger_total(1,i) = sum(matriz_concat(1:4,i));  
      matriz_concat(:,i)= matriz_concat(:,i)*(carga/Ger_total(1,i)); %corrige geração
end
     
    %calculo do custo de geração depois de mutado sem penalização

   for k=(Pop+1):1:(Pop+Pop)
        for i=1:1:Geradores %calculo direto do custo de geração apartir do custo de cada gerador
              aux_custo(i,k)=Ger(i,3)+Ger(i,4)*matriz_concat(i,k)+Ger(i,5)*power(matriz_concat(i,k),2);
              if i==4 
              matriz_concat(5,k)=sum(aux_custo(:,k));
              end
        end
   end
   matriz_custo_sp_interface=matriz_concat;
  %----------------------------------AVALIAR-------------------------------
  %verificão dos limites de geraçao
     custo_pen_mut=matriz_concat(5,:); % inicializa variavel que recebera os custos com penalização
    %custo_pen_mut(1,:)=0;
    custo_pen_mut2=matriz_concat(5,:);
    custo_pen_mut2(1,:)=0;
    
   % calculo dos custos com penalização da matriz Pop original
    for j=(Pop+1):1:(Pop+Pop)
      for i = 1:1:Geradores
        if (matriz_concat(i,j) > lim_Geradores(i,2)) %recebe penalização caso exceda o limite do gerador i
            custo_pen(1,j)=matriz_concat(5,j)+M1*(matriz_concat(i,j)-lim_Geradores(i,2));
            custo_pen_mut2(1,j)=matriz_concat(5,j)+M1*(matriz_concat(i,j)-lim_Geradores(i,2));   
        end
            if (matriz_concat(i,j)<lim_Geradores(i,1)) %recebe penalização caso não atinga o minimo estipulado para o gerador i
            custo_pen(1,j)=matriz_concat(5,j)+M2*(lim_Geradores(i,1)-matriz_concat(i,j));
            custo_pen_mut2(1,j)=matriz_concat(5,j)+M2*(lim_Geradores(i,1)-matriz_concat(i,j));
            end
        end
    end
    matriz_concat(5,:)=custo_pen;
    matriz_custo_cp_interface=matriz_concat;
   %-----MANIPULAR GERAÇÃO NO CASO DE OS LIMITES SEJAM DESRESPEITADOS------ 
   nova = matriz_concat(~ismember(1:size(matriz_concat, 1), 5), :); %reduz a matriz Pop+Clone a linha referente aos custos
   matriz_aux=nova;   %determina uma matriz auxiliar para receber os resultados que excedentes e que não atigem os limites de geração
   matriz_aux(:,:)=0; %seta a 0
   excesso_superior=nova; %variavel para armazenar o excesso  
   excesso_inferior=nova; %variavel para armazenar o excesso 
   excesso_superior(:,:)=0; %seta a 0 
   excesso_inferior(:,:)=0; %seta a 0
   
   ll=0;    %usado para sair do ciclo
   contar_erros=0; % usado para populaçoes muito grandes
   while (ll==0)
   for j=1:1:Pop+Pop
    for i=1:1:Geradores
         if nova(i,j)>lim_Geradores(i,2)  % se exceder o limite 
            matriz_aux(i,j)=nova(i,j);    % armazena o valor atual de geração na matriz auxiliar
            excesso_superior(i,j)=nova(i,j)-lim_Geradores(i,2) ;   %calcula a diferençã entre os limite e a geração atribuida
            nova(:,j)=(nova(:,j)+excesso_inferior(i,j)/3);  %divide o excedente entre os geradores restantes
            nova(i,j)=lim_Geradores(i,2);
         end
         if nova(i,j)<lim_Geradores(i,1)   
            matriz_aux(i,j)=nova(i,j);
            excesso_inferior(i,j)=lim_Geradores(i,1)- nova(i,j);
            nova(:,j)=(nova(:,j)-excesso_inferior(i,j)/3);
            nova(i,j)=lim_Geradores(i,1);
          end
      end
   end
  
   contar_erros=contar_erros+1;
   lim=any(matriz_aux(:) > 0 ); %enquanto matriz_aux apresentar valores excedentes não 
                               %sai do ciclo caso contrario os valores de geração saem corrigidos
           if( lim == 0 || contar_erros>20 )
            matriz_concat_aux2=nova; % variavel auxiliar que recebe os valores de geração corigidos 
            
            for k=1:1:(Pop+Pop) %calculo dos custos ja considerando os limites das linhas
                for i=1:1:Geradores
                  aux_2(i,k)=Ger(i,3)+Ger(i,4)*matriz_concat_aux2(i,k)+Ger(i,5)*power(matriz_concat_aux2(i,k),2);
                      if i==4 
                           matriz_concat_aux2(5,k)=sum(aux_2(:,k));
                      end
                end
            end
            matriz_concat_aux2;
            nova(:,:)=0;
              ll=1; %sai do ciclo
           end
      aux_2(:,:)=0; %seta a 0 e prepara para a proxima iteração
      excesso_superior(:,:)=0; %seta a 0 e prepara para a proxima iteração
      excesso_inferior(:,:)=0; %seta a 0 e prepara para a proxima iteração
      matriz_aux(:,:)=0; %seta a 0 e prepara para a proxima iteração
      
   end
   ll=0; %seta ciclo a 0 e prepara para a proxima iteração
   
  matriz_concat=matriz_concat_aux2; %retorna a ser matriz Pop+Clone (corrigida limites das linhas + penalidades)
  matriz_custo_cplimites_interface=matriz_concat;
  %------------------------------SELECIONAR--------------------------------
   aux=matriz_concat; % matriz auxiliar que recebe a matriz Pop+Clone
   sigmamelhor=sig;   % vetorque ira receber os melhores sigmas 
   sigmamelhor(1,:)=0; % seta a zero
 
   for i=1:1:Pop+Pop
          [custo,pos_na_Pop] = min(aux(5,:)); %seleciona o valor de custo minimo entre a Pop e Clone
          matriz_melhor(:,i)=matriz_concat(:,pos_na_Pop); %armazena na matriz de forma recursiva as gerações +custo
          sigmamelhor(1,i) = sig(1,pos_na_Pop);  %recebe o sigma referente ao melhor custo para posição do menor custo associado
          customelhor(1,i) = matriz_concat(5,pos_na_Pop); %recebe menor custo associado a
          aux(5,pos_na_Pop)=aux(5,pos_na_Pop)+100000; % para o valor selecionado é add 100000 para que na proxima recursão não seja selecionado
   end
    matriz_melhor_interface=matriz_melhor;
        matriz_customelhor_interface=customelhor;

     matriz_orig(:,:)=0; %seta a matriz Pop a zero
     matriz_orig=matriz_melhor(:,1:Pop); % seleciona os piores valores de despacho da matriz ordenada dos custos mais baixos pra os mais altos
     sig=sigmamelhor;   %selciona e arlmazena os melhores sigmas para ser usado na proxima iteração 
     custo_iter_final(1,ii)=customelhor(1,1);  %armazena o melhor custo encontrado para essa iteração
     sigma_iter(1,ii)=sigmamelhor(1,1);% aramazena os melhor sigma da iteração ii
    
     matriz_custoietr_interface=custo_iter_final;
     matriz_sigma_iter_interface=sigma_iter;
    
    evo_geracaoG11(1,ii)=matriz_melhor(1,1); %armazena melhores geraçãoG11 para iterraçoes realizadas
    evo_geracaoG12(1,ii)=matriz_melhor(2,1); %armazena melhores geraçãoG12 para iterraçoes realizadas
    evo_geracaoG41(1,ii)=matriz_melhor(3,1); %armazena melhores geraçãoG41 para iterraçoes realizadas
    evo_geracaoG42(1,ii)=matriz_melhor(4,1); %armazena melhores geraçãoG41 para iterraçoes realizadas
    
    num_iter(1,ii)=ii; %armazena as iterraçoes realizadas
    melhores_ger(1:4,1)=matriz_melhor(1:4,1);
    matriz_melhor_ger=melhores_ger;
    matriz_melhor(:,:)=0;
    %-------------------------CRITERIO DE PARAGEM-------------------------- 
if ii>=2
    if custo_iter_final(1,ii-1)~=custo_iter_final(1,ii)
    cnt=0;
    elseif custo_iter_final(1,ii-1)==custo_iter_final(1,ii)
    cnt=cnt+1;
    end
    if cnt==100;
    break;
    end
end
   ii=ii+1; %incrementa iteração
end
end
