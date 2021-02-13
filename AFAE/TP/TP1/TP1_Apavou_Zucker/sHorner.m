function res = sHorner(p,x)
p_r=sym(p,'f');
x_r= sym(x,'f');
res=Horner(p_r,x_r);
end

%When sym uses the floating-point to rational mode, 
%it returns the symbolic form for all values in the 
%form N*2^e or -N*2^e, where N >= 0 and e are integers. 
%The returned symbolic number is a precise rational number 
%that is equal to the floating-point value. For example, 
%sym(1/10,'f') returns 3602879701896397/36028797018963968.