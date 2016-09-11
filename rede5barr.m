function mpc = transito_potencia 
%CASE5  Power flow data for modified 5 bus, 5 gen case based on PJM 5-bus system
%   Please see CASEFORMAT for details on the case file format.
%
%   Based on data from ...
%     F.Li and R.Bo, "Small Test Systems for Power System Economic Studies",
%     Proceedings of the 2010 IEEE Power & Energy Society General Meeting

%   Created by Rui Bo in 2006, modified in 2010, 2014.c
%   Distributed with permission.

%   MATPOWER

%% MATPOWER Case Format : Version 2
mpc.version = '2';

%%-----  Power Flow Data  -----%%
%% system MVA base
mpc.baseMVA = 100;

%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
mpc.bus = [
     	1	3	0   0	0	0	1	1	0	150	1	1.02   1.02;
        2	1	0	0	0	0	1	1	0	150	1	1.10   0.90;
        3	1	0	0	0	0	1	1	0	150	1	1.10   0.90;
        4	2	0	0	0	0	1	1	0	150	1   1.01   1.01;
        5	1	0	0	0	0	1	1	0	150	1	1.10   0.90;
];

%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf
mpc.gen = [
	1	0	0	999	-999	1	100	1	90	30	0	0	0	0	0	0	0	0	0	0	0;
    1	0	0	999	-999	1   100	1	60	20	0	0	0	0	0	0	0	0	0	0	0;
	4	0	0   999	-999	1	100	1	80	40	0	0	0	0	0	0	0	0	0	0	0;
	4	0	0	999	-999	1	100	1	70	30	0	0	0	0	0	0	0	0	0	0	0;
];

%% branch data
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax
mpc.branch = [
	1	2	0.03	0.08	0	75	0   0	0	0	1	-360	360;
	1	5	0.09	0.32	0	102	0	0	0	0	1	-360	360;
	2	3	0.05	0.08	0	45	0	0	0	0	1	-360	360;
	2	5	0.05	0.16	0	100	0	0   0	0	1	-360	360;
	3	4	0.04    0.10	0	90	0	0	0	0	1	-360	360;
	4	5	0.04	0.10	0	87	0	0	0	0	1	-360	360;
];

%%-----  OPF Data  -----%%
%% generator cost data
%	1	startup	shutdown	n	x1	y1	...	xn	yn
%	2	startup	shutdown	n	c(n-1)	...	c0
mpc.gencost = [
	
           2	0	0	3	0.06    20  800;
           2	0	0	3	0.10    16  800;
           2	0	0	3	0.08    20  800;
           2	0	0	3	0.11    22  800;
 	
];
