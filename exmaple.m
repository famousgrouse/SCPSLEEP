load hospital.mat;
X = [hospital.Age hospital.Weight];
Y = [20 162; 30 169; 40 168; 50 170; 60 171]; 
Idx = knnsearch(X,Y);


