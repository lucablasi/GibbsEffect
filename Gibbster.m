function Gibbster
%Análisis y visualización del efecto de Gibbs
%Creado por: Luca Blasi

try
%Reset GUI settings upon opening
appdata = get(0,'ApplicationData');
ad = fieldnames(appdata);
for ii = 1:numel(ad)
  rmappdata(0,ad{ii});
end

%Main figure
f = figure('Visible','off','Position',[0 0 1000 500],'Resize','off');

%Error messages
handles.e = figure('Visible','off','Position',[0 0 200 100],...
    'Resize','off','CloseRequestFcn',@MyRequest);
handles.error = uicontrol(handles.e,'Style','text','Position',[20 70 160 50],...
    'String','Algo hiciste mal de tu lado, porque el codigo es perfecto.',...
    'FontName','Trebuchet MS','FontSize',10);
handles.errorok = uicontrol(handles.e,'Style','pushbutton','String','Ufa',...
    'Position',[25 20 150 30],'FontName','Trebuchet MS',...
    'Callback',{@errorok_Callback, handles});
movegui(handles.e,'center');
handles.e.Name = '';
handles.e.MenuBar = 'none';
handles.e.NumberTitle = 'off';

%Graph
handles.ax = axes(f,'Units','Pixels','Position',[50 50 650 450],...
    'Box','on','XLim',[-3,3],'YLim',[-1.5, 1.5],'XGrid','on','YGrid','on');

%Options, buttons, and such
handles.sig_select = uicontrol(f,'Style','popupmenu','Position',[730 500 240 0],...
    'String',{'Tren de pulsos','Diente de sierra','Triangular'},'FontSize',10);

%Efecto de Gibbs button group
bg2 = uibuttongroup(f,'Title','Efecto de Gibbs','Units','pixels',...
    'Position',[730 50 240 150],'BorderWidth',2,'FontSize',12,...
    'FontName','Trebuchet MS','TitlePosition','centertop');

    handles.text1a = uicontrol(bg2,'Style','text','Position',[10 105 140 20],...
        'String','Error cuadrado medio:','FontSize',10,'HorizontalAlignment','right');
    handles.text2a = uicontrol(bg2,'Style','text','Position',[10 80 140 20],...
        'String','Salto:','FontSize',10,'HorizontalAlignment','right');
    handles.text3a = uicontrol(bg2,'Style','text','Position',[10 55 140 20],...
        'String','Excedente:','FontSize',10,'HorizontalAlignment','right');
    handles.text4a = uicontrol(bg2,'Style','text','Position',[10 30 140 20],...
        'String','Error relativo:','FontSize',10,'HorizontalAlignment','right');
    handles.text5a = uicontrol(bg2,'Style','text','Position',[10 5 140 20],...
        'String','Delta temporal:','FontSize',10,'HorizontalAlignment','right');
    
    line = uibuttongroup(bg2,'Units','pixels','Position',[155 10 1 110],...
        'BorderType','line','HighlightColor','black'); %#ok<NASGU>
    
    %btw, entran 6 digitos
    handles.text1b = uicontrol(bg2,'Style','text','Position',[160 105 50 20],...
        'String','','FontSize',10,'HorizontalAlignment','left');
    handles.text2b = uicontrol(bg2,'Style','text','Position',[160 80 50 20],...
        'String','','FontSize',10,'HorizontalAlignment','left');
    handles.text3b = uicontrol(bg2,'Style','text','Position',[160 55 50 20],...
        'String','','FontSize',10,'HorizontalAlignment','left');
    handles.text4b = uicontrol(bg2,'Style','text','Position',[160 30 50 20],...
        'String','','FontSize',10,'HorizontalAlignment','left');
    handles.text5b = uicontrol(bg2,'Style','text','Position',[160 5 50 20],...
        'String','','FontSize',10,'HorizontalAlignment','left');

%Criterio de corte button group
bg1 = uibuttongroup(f,'Title','Criterio de corte','Units','pixels',...
    'Position',[730 280 240 180],'BorderWidth',2,'FontSize',12,...
    'FontName','Trebuchet MS','TitlePosition','centertop');
    handles.edit1 = uicontrol(bg1,'Style','edit','Position',[10 90 210 30],...
        'FontSize',10,'HorizontalAlignment','left','Enable','on');
    handles.edit2 = uicontrol(bg1,'Style','edit','Position',[10 20 210 30],...
        'FontSize',10,'HorizontalAlignment','left','Enable','off');
    handles.r1 = uicontrol(bg1,'Style','radiobutton','Position',[10 120 230 30],...
        'String','Número de armónicos:','FontSize',10,...
        'Callback',{@r1_Callback, handles});
    handles.r2 = uicontrol(bg1,'Style','radiobutton','Position',[10 50 230 30],...
        'String','Error cuadrático medio:','FontSize',10,...
        'Callback',{@r2_Callback, handles});
    
%Ventana de parámetros de señal
handles.p = figure('Visible','off','Position',[0 0 260 140],'Resize','off',...
    'CloseRequestFcn',@MyRequest);

    handles.p_L = uicontrol(handles.p,'Style','edit','Position',[140 150 100 20],...
        'String','6');
    handles.p_T = uicontrol(handles.p,'Style','edit','Position',[140 120 100 20],...
        'String','2');
    handles.p_a = uicontrol(handles.p,'Style','edit','Position',[140 90 100 20],...
        'String','1');
    handles.p_fs = uicontrol(handles.p,'Style','edit','Position',[140 60 100 20],...
        'String','10000');

    p_L_text = uicontrol(handles.p,'Style','text','Position',[20 150 100 20],...
        'FontName','Trebuchet MS','HorizontalAlignment','right',...
        'String','Duración:');
    p_T_text = uicontrol(handles.p,'Style','text','Position',[20 120 100 20],...
        'FontName','Trebuchet MS','HorizontalAlignment','right',...
        'String','Periodo:');
    p_a_text = uicontrol(handles.p,'Style','text','Position',[20 90 100 20],...
        'FontName','Trebuchet MS','HorizontalAlignment','right',...
        'String','Amplitud:');
    p_fs_text = uicontrol(handles.p,'Style','text','Position',[20 60 100 20],...
        'FontName','Trebuchet MS','HorizontalAlignment','right',...
        'String','Sample rate:');
    handles.p_ok = uicontrol(handles.p,'Style','pushbutton','Position',[260/3 20 260/3 30],...
    'String','Ok!','FontName','Trebuchet MS','Callback',{@p_ok_Callback, handles});
    
    movegui(handles.p,'center');
    handles.p.Name = 'Parámetros';
    handles.p.MenuBar = 'none';
    handles.p.NumberTitle = 'off';

b_calc = uicontrol(f,'Style','pushbutton','Position',[730 220 240 40],...
'String','Calculate!','FontSize',12,'FontName','Trebuchet MS',...
'Callback',{@calculate_Callback, handles});

%Menu
m_param = uimenu(f,'Label','Parámetros','Callback',{@p_Callback, handles});

movegui(f,'center');
f.Name = 'Gibbster';
f.MenuBar = 'none';
f.NumberTitle = 'off';
f.Visible = 'on';
catch
     set(handles.e,'Visible','on');
end

%GUI functions
%-------------------------------------------------------------------------%
function calculate_Callback(~,~,handles)
%Calcula y grafica TODO
    
try
s.L  = str2double(get(handles.p_L,'String'));
s.T  = str2double(get(handles.p_T,'String'));
s.a  = str2double(get(handles.p_a,'String'));
s.fs = str2double(get(handles.p_fs,'String'));

%Caso según tipo de señal
switch get(handles.sig_select,'Value')
    case 1
        s = trencito(s);
    case 2
        s = diente(s);
    case 3
        s = triangulo(s);
end

%Caso según opcion por N de armónicos o por error
switch get(handles.r1,'Value')
    case 1
        s.N = str2double(get(handles.edit1,'String'));
        s = Fourier(s);
        s = Gibbs(s);
        s = ECM(s);
        set(handles.text1a,'String','Error cuadrado medio:')
        set(handles.text1b,'String',round(s.ecm,4));
        set(handles.text2b,'String',round(s.j,4));
        set(handles.text3b,'String',round(s.dx,4));
        string4 = string(round(abs(s.dx/s.j*100),2)) + '%';
        set(handles.text4b,'String',string4);
        set(handles.text5b,'String',round(s.rt,4));
    case 0
        s.ecm = str2double(get(handles.edit2,'String'));
        
        %El numero de armónicos necesarios es inversamente proporcional
        %al error "e" buscado (N=p/e). Además, y muy copado, la proporción
        %es constante para una señal y su desarrollo de Fourier. Entonces,
        %en vez de iterar varias veces y cheqear el error en cada iteración
        %hasta que sea igual o menor, se encuentra la proporción una vez
        %para un n fijo, y con esa proporción ya se puede saber la cantidad
        %de armónicos necesarios para cualquier error sin iterar un montón.
        s.N = 50;
        s = Fourier(s);
        p = ECM(s);
        s.N = floor((s.N*p.ecm)/s.ecm);
        if s.N < 1
            s.N = 1;
        end
        
        s = Fourier(s);
        s = Gibbs(s);
        set(handles.text1a,'String','Número de armónicos:')
        set(handles.text1b,'String',round(s.N,4));
        set(handles.text2b,'String',round(s.j,4));
        set(handles.text3b,'String',round(s.dx,4));
        string4 = string(round(abs(s.dx/s.j*100),2)) + '%';
        set(handles.text4b,'String',string4);
        set(handles.text5b,'String',round(s.rt,4));
end

cla
plot(s.t,s.x,'LineWidth',1);
grid on; hold on;
plot(s.t,s.X,'LineWidth',1);
xlim([s.t(1),s.t(end)]);
if get(handles.sig_select,'Value') == 3  %que quede centrado el triangulo
    ylim([-0.5*s.a,1.5*s.a]);
else
    ylim([-1.5*s.a,1.5*s.a]);
end
legend('Señal','Serie de Fourier');

setappdata(0,'s',s);

catch
     set(handles.e,'Visible','on');
end
end
%-------------------------------------------------------------------------%
function p_Callback(~,~,handles)
%Hace visible la ventana de los parámetros
try
set(handles.p,'Visible','on');
catch
     set(handles.e,'Visible','on');
end
end
%-------------------------------------------------------------------------%
function p_ok_Callback(~,~,handles)
%Cierra la ventana de parámetros

try
handles.p.Visible = 'off';
movegui(handles.p,'center');
catch
     set(handles.e,'Visible','on');
end
end
%-------------------------------------------------------------------------%
function MyRequest(object_handle,~,~)
%Cierra la ventana
    
set(object_handle,'Visible','off');
movegui(object_handle,'center');
end
%-------------------------------------------------------------------------%
function errorok_Callback(~,~,handles)
%Hace visible la ventana de error
    
handles.e.Visible = 'off';
movegui(handles.e,'center');
end
%-------------------------------------------------------------------------%
function r1_Callback(object_handle,~,handles)
%Greys out opposite input box for radio button options

try
    switch get(object_handle,'value')
        case 0
            set(handles.edit1,'Enable','off');
            set(handles.edit2,'Enable','on');
        case 1
            set(handles.edit1,'Enable','on');
            set(handles.edit2,'Enable','off');
    end
catch
     set(handles.e,'Visible','on');
end
end
%-------------------------------------------------------------------------%
function r2_Callback(object_handle,~,handles)
%Greys out opposite input box for radio button options

try
    switch get(object_handle,'value')
        case 0
            set(handles.edit1,'Enable','on');
            set(handles.edit2,'Enable','off');
        case 1
            set(handles.edit1,'Enable','off');
            set(handles.edit2,'Enable','on');
    end
catch
    set(handles.e,'Visible','on');
end
end
%-------------------------------------------------------------------------%

%Proccesing functions
%-------------------------------------------------------------------------%
function s = Fourier(s)
%Aplica serie de Fourier de N elementos sobre una señal periódica (T)
%de variable ind. t y variable dep. x

t = s.t;
x = s.x;
T = s.T;
N = s.N;

%Indices de intervalo (-T/2 ; T/2)
a = find(t>=-T/2,1,'first');
b = find(t<=T/2,1,'last');
tT = t(a:b);
xT = x(a:b);

%Ecuación de Fourier
w = 2*pi/T;
a0 = 2/T*trapz(tT,xT);
n = 1:N;
an = zeros(1,N);
bn = zeros(1,N);
for i = n
    an(i) = 2/T*trapz(tT,xT.*cos(i*w*tT));
    bn(i) = 2/T*trapz(tT,xT.*sin(i*w*tT));
end

s.X = a0/2 + an*cos(n'*w*t)+bn*sin(n'*w*t);
end
%-------------------------------------------------------------------------%
function s = diente(s)
%Genera señal diente de sierra de largo L (centro en 0),
%periodo T, pendiente a, y frecuencia de sampleo fs

L = s.L;
T = s.T;
a = s.a;
fs = s.fs;

s.t = -L/2:1/fs:L/2;
s.x = a*(mod(s.t-T/2,T)-T/2);
end
%-------------------------------------------------------------------------%
function s = triangulo(s)
%Genera señal triangular de largo L (centro en 0), periodo T, pendiente a
%y frecuencia de sampleo fs

L = s.L;
T = s.T;
a = s.a;
fs = s.fs;


s.t = -L/2:1/fs:L/2;
ti = 0:1/fs:T-1/fs;
xi = [a*ti(ti<T/2) -a*(ti(ti>=T/2)-T)];

%Repetir el triangulo para llenar largo L y recortar el exceso
n = 2*ceil(L/2*fs/length(xi));
r = (n*length(xi)-L*fs)/2;
x = repmat(xi,1,n);
if r == 0
    s.x = [x 0];
else
    s.x = x(r+1:end-r+1);
end
end
%-------------------------------------------------------------------------%
function s = trencito(s)
%Genera señal tren de pulsos de largo L (centro en 0), periodo T,
%amplitud a, y frecuencia de sampleo fs

L = s.L;
T = s.T;
a = s.a;
fs = s.fs;

s.t = -L/2:1/fs:L/2;
ti = 0:1/fs:T-1/fs;
xi(ti<T/2)=a;
xi(ti>=T/2)=-a;

%Repetir el pulso para llenar largo L y recortar el exceso
n = 2*ceil(L/2*fs/length(xi));
r = (n*length(xi)-L*fs)/2;
x = repmat(xi,1,n);
if r == 0
    s.x = [x x(end)];
else
    s.x = x(r+1:end-r+1);
end
end
%-------------------------------------------------------------------------%
function  s = Gibbs(s)
%Analiza el efecto de Gibbs dada una señal discontinua (t,x) y una serie
%de Fourier de la misma (X)

t = s.t;
x = s.x;
X = s.X;

%Busca picos de x y X
[x_max,i] = max(x(t>=0));
i = i + length(x(t<0));
[X_max,I] = findpeaks(X);
%Se utilizan los picos de X que tengan el mismo signo que los picos de x
%(en este código siempre positivos)
if x_max >= 0
    I = I(X_max>=0);
    X_max = X_max(X_max>=0);
else
    I = I(X_max<0);
    X_max = X_max(X_max<0);
end
%Se encuentra el pico de X más cercano al pico de x
[~,p] = min(abs(I-i));
I = I(p);
X_max = X_max(p);

fs = (length(t)-1)/(t(end)-t(1));
i = i/fs;
I = I/fs;

s.dt = abs(I - i);
s.dx = X_max - x_max;
s.rt = s.dt/i;
s.j = max(x)-min(x);
end
%-------------------------------------------------------------------------%
function s = ECM(s)
%Calcula el error cuadrado medio entre dos señales

x = s.x;
X = s.X;

L = length(x);
s.ecm = sum((x-X).^2)./L;
end

end