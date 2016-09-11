function varargout = DOIC_TPII_interface(varargin)
% DOIC_TPII_INTERFACE MATLAB code for DOIC_TPII_interface.fig
%      DOIC_TPII_INTERFACE, by itself, creates a new DOIC_TPII_INTERFACE or raises the existing
%      singleton*.
%
%      H = DOIC_TPII_INTERFACE returns the handle to a new DOIC_TPII_INTERFACE or the handle to
%      the existing singleton*.
%
%      DOIC_TPII_INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DOIC_TPII_INTERFACE.M with the given input arguments.
%
%      DOIC_TPII_INTERFACE('Property','Value',...) creates a new DOIC_TPII_INTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DOIC_TPII_interface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DOIC_TPII_interface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DOIC_TPII_interface

% Last Modified by GUIDE v2.5 24-May-2015 07:21:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DOIC_TPII_interface_OpeningFcn, ...
                   'gui_OutputFcn',  @DOIC_TPII_interface_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);

if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before DOIC_TPII_interface is made visible.
function DOIC_TPII_interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DOIC_TPII_interface (see VARARGIN)

% Choose default command line output for DOIC_TPII_interface
handles.output = hObject;
    
    set(handles.slider4,'Value',200);
    aa=get(handles.slider4,'Value');
    set(handles.text11,'String',num2str(aa))
    set(handles.slider1,'Value',100);
    aa=get(handles.slider1,'Value');
    set(handles.text12,'String',num2str(aa))
    filename='rede.bmp';           
    h=imread(filename);
    axes(handles.axes1);
    image(h);
    set(gca,'xtick',[],'ytick',[])
    
global matriz_orig_interface_sp
global matriz_orig_interface_cp
global matriz_melhor_ger
global matriz_pop_pop_interface
global matriz_custo_sp_interface
global matriz_custo_cp_interface
global matriz_custo_cplimites_interface
global matriz_melhor_interface
global matriz_customelhor_interface
global matriz_custoietr_interface
global matriz_sigma_iter_interface
global num_iter
global evo_geracaoG11
global evo_geracaoG12
global evo_geracaoG41
global evo_geracaoG42
% Update handles structure
guidata(hObject, handles);


function varargout = DOIC_TPII_interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global matriz_orig_interface_sp
global matriz_orig_interface_cp
global matriz_melhor_ger
global matriz_pop_pop_interface
global matriz_custo_sp_interface
global matriz_custo_cp_interface
global matriz_custo_cplimites_interface
global matriz_melhor_interface
global matriz_customelhor_interface
global matriz_custoietr_interface
global matriz_sigma_iter_interface
global num_iter
global evo_geracaoG11
global evo_geracaoG12
global evo_geracaoG41
global evo_geracaoG42

pop_ini=str2double(get(handles.edit1,'String'));
Factor_aprendiz=str2double(get(handles.edit2,'String'));
sigma_0=str2double(get(handles.edit3,'String'));
n_iter=str2double(get(handles.edit4,'String'));
carga_0=get(handles.slider4,'Value');
[matriz_orig_interface_sp,matriz_orig_interface_cp, matriz_melhor_ger,matriz_pop_pop_interface, matriz_custo_sp_interface,matriz_custo_cp_interface,matriz_custo_cplimites_interface,matriz_melhor_interface,matriz_customelhor_interface,matriz_custoietr_interface,matriz_sigma_iter_interface,num_iter,evo_geracaoG11,evo_geracaoG12,evo_geracaoG41,evo_geracaoG42]=corpo(pop_ini,Factor_aprendiz,sigma_0,n_iter,carga_0);


axes(handles.axes2);
plot(num_iter,matriz_custoietr_interface);
title('Evolução do Custo do Melhor Indivíduo de cada iteração');
xlabel('Nº da Iteração');
ylabel('Custo [R/MWh]');
grid on

axes(handles.axes3);
plot(num_iter, evo_geracaoG11, num_iter, evo_geracaoG12, num_iter, evo_geracaoG41, num_iter, evo_geracaoG42);
grid on
title('Evolução da Gerção para os Melhores Indivíduos');
legend('G11', 'G12','G41','G42');
xlabel('Nº de Iterações ');
ylabel('Geração [MW]');

figure
plot(num_iter,matriz_sigma_iter_interface)
title('Evolução da Taxa de Mutação do melhor Indivíduo')
xlabel('Nº da Iteraçôes')
ylabel('Taxa de Mutação')
grid on

% --- Executes on selection change in lista.
function lista_Callback(hObject, eventdata, handles)
 pop_ini=str2double(get(handles.edit1,'String'))
%  Factor_aprendiz=str2double(get(handles.edit2,'String'))
%  sigma_0=str2double(get(handles.edit3,'String'))
%  n_iter=str2double(get(handles.edit4,'String'))
%  carga_0=get(handles.slider4,'Value');
% [matriz_orig_interface_sp,matriz_orig_interface_cp, matriz_melhor_ger,matriz_pop_pop_interface,matriz_custo_sp_interface,matriz_custo_cp_interface,matriz_custo_cplimites_interface,matriz_melhor_interface,matriz_customelhor_interface,matriz_custoietr_interface,matriz_sigma_iter_interface,num_iter,evo_geracaoG11,evo_geracaoG12,evo_geracaoG41,evo_geracaoG42]=corpo(pop_ini,Factor_aprendiz,sigma_0,n_iter,carga_0)
global matriz_orig_interface_sp
global matriz_orig_interface_cp
global matriz_melhor_ger
global matriz_pop_pop_interface
global matriz_custo_sp_interface
global matriz_custo_cp_interface
global matriz_custo_cplimites_interface
global matriz_melhor_interface
global matriz_customelhor_interface
global matriz_custoietr_interface
global matriz_sigma_iter_interface
global num_iter
global evo_geracaoG11
global evo_geracaoG12
global evo_geracaoG41
global evo_geracaoG42
 posicao=get(hObject,'Value')  
 if (posicao==1)


 cnames = {'Gerações Pop'};
 dnames = {'G11' 'G22' 'G41' 'G42' 'Cst_€'};

 set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'Data',matriz_orig_interface_sp);
              
end
if (posicao==2)


 cnames = {'Gerações Pop' '' '' '' ''};
 dnames = {'G11' 'G22' 'G41' 'G42' 'Cst_€'};

 set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'Data',matriz_orig_interface_cp);
end
              
if (posicao==3)
 
 

 cnames = {'Gerações Pop' '' '' '' 'Gerações Pop+Mut.'};
 dnames = {'G11' 'G22' 'G41' 'G42' 'Cst_€'};

 set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'Data',matriz_pop_pop_interface);
end       

if (posicao==4)


 cnames = {'Gerac_Pop', '', '', '', 'Gerac_Pop_mut'};
 dnames = {'G11' 'G22' 'G41' 'G42' 'Cst_€'};

 set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'Data',matriz_custo_sp_interface);
              
end  
if (posicao==5)


 cnames = {'Gerac_Pop', '', '', '', 'Gerac_Pop_mut'};
 dnames = {'G11' 'G22' 'G41' 'G42' 'Cst_€'};

 set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'Data',matriz_custo_cp_interface);
end  


if (posicao==6)
 cnames = {'Gerac_Pop', '', '', '', 'Gerac_Pop_mut'};
 dnames = {'G11' 'G22' 'G41' 'G42' 'Cst_€'};

 set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'Data',matriz_custo_cplimites_interface);
end  
if (posicao==7)

 cnames = {'Gerac_Pop', '', '', '', 'Gerac_Pop_mut'};
 dnames = {'G11' 'G22' 'G41' 'G42' 'Cst_€'};

 set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'Data',matriz_melhor_interface);
end  
if (posicao==8)
 
 format shortG
 cnames = {'sig1_bet', 'sig2_best', '...', '...', '...'};
 dnames = {'sigma'};

 set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'Data',matriz_sigma_iter_interface);
end  


if (posicao==9)

 cnames = {'Custo1_best', 'Custo2_best', '...', '..', '.'};
 dnames = {'Cst_€'};

 set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'Data',matriz_custoietr_interface);
end  

if (posicao==10)


 cnames = {'Melhor_Despacho MW',};
 dnames = {'G11' 'G22' 'G41' 'G42' 'Cst_€'};
 
 Ger=[ 
     30 90 800 20 0.06
     20 60 800 16 0.10
     40 80 800 20 0.08
     30 70 800 22 0.11];
       
                for i=1:1:4
                  aux_2(i,1)=Ger(i,3)+Ger(i,4)*matriz_melhor_ger(i,1)+Ger(i,5)*power(matriz_melhor_ger(i,1),2);
                      if i==4 
                           matriz_melhor_ger(5,1)=sum(aux_2(:,1));
                      end
                end
           
 set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'ColumnName',cnames);
              set(handles.tabela1,'RowName',dnames);
              set(handles.tabela1,'Data',matriz_melhor_ger);
end


 if (posicao==11)
 format shortG
 cnames = {'Despacho_MW' 'De_Brr' 'Para_Brr' 'limite das linhas' 'limite das linhas corrigido' 'TP_DC_ik' 'TP_DC_k1' 'excede_0_1'};
 dnames = {'L12' 'L13' 'L23' 'L25' 'L34' 'L45'};
 
s=[[1 2 0.03 0.08 75];[1 5 0.09 0.32 102];[2 3 0.05 0.08 45];[2 5 0.05 0.16 100];[3 4 0.04 0.10 90];[4 5 0.04 0.10 87]];

%                       Classificão dos barramentos da Rede
%-------------------------------------------------------------------------------------- 
    lim_linhas = s(:,5);          % Vetor de Adimitancia de terra, B/2...

Ger=[ 
     30 90 800 20 0.06
     20 60 800 16 0.10
     40 80 800 20 0.08
     30 70 800 22 0.11];


linhas_aux=[1 1; 1 5; 2 3; 2 5; 3 4; 4 5];
linhas_aux =[linhas_aux lim_linhas];

lim_Geradores = Ger(:,1);     % Prenche matriz de intervalos para valore minimos 
lim_Geradores(:,2) = Ger(:,2);     % Prenche matriz  de intervalos para valore maximos 
bar_gerr=[1 1; 1 2; 4 1; 4 2];
aux=[bar_gerr Ger];

mpc = loadcase('rede5barr');              %Carrega a folha de especificações da rede de 5 barramentos do trabalho 
mpopt = mpoption( 'out.all',1,'verbose',1,'out.force',1);

carga_aux =get(handles.slider4,'Value')/5;
mpc.gen(:,2)=matriz_melhor_ger(1:4,1)
mpc.bus(:,3)=carga_aux;
V=get(handles.slider1,'Value');
b=0.85*lim_linhas*V/100;
% mpc.branch(:,6)=b;

results= rundcpf(mpc,mpopt);            % results recebe os resultados armazenados na struct's geradas pelas funções do MatPower 
% O resultado do transito de potencia nos permite determinar: 
%valores centrais(V e thetas nos barramentos para o cenario de rede fornecido);
tabela_pot_ik=results.branch(:,14);         %transito de potencia ativa Pik
tabela_pot_ki=results.branch(:,16);         %transito de potencia ativa Pki

%resultados_comp=[b
[final ~]=size(b);
aa=b;
aa(:,1)=0;

for i=1:1:final
    if(b(i,1)<abs(tabela_pot_ik(i,1))||tabela_pot_ik(i,1)<0)
       aa(i,1)=1; 
    end
end
 matriz_melhor_ger(5,1)=0;
 matriz_melhor_ger(6,1)=0;
matriz_resultado = [matriz_melhor_ger linhas_aux  b results.branch(:,14) tabela_pot_ki  aa];
set(handles.tabela1,'ColumnName',cnames);
set(handles.tabela1,'RowName',dnames);
set(handles.tabela1,'Data',matriz_resultado);
end
    


% --- Executes during object creation, after setting all properties.
function lista_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lista (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x=50;
V=get(handles.slider1,'Value')
if(V<x)
    V=0;
set(handles.slider1,'Value',x+V)
end
valor=get(hObject,'Value')
set(handles.text12,'String',num2str(valor))


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider4_Callback(hObject, eventdata, handles)

x=125;
V=get(handles.slider4,'Value')
if(V<x)
    V=0;
set(handles.slider4,'Value',x+V)
end
valor=get(hObject,'Value')
set(handles.text11,'String',num2str(valor))


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes when entered data in editable cell(s) in tabela1.
function tabela1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to tabela1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
