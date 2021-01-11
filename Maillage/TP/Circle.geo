DefineConstant[
	R = {1, Min 0.5, Max 10, Step 0.1, Name "R"},
	h = {0.1, Min 0.01, Max 10, Step 0.01, Name "h"}
  ];
  xc = 0;
  yc = 0;
  Point(1) = {xc, yc, 0, h};
  Point(2) = {xc + R, yc, 0, h};
  Point(3) = {xc, yc + R, 0, h};
  Point(4) = {xc - R, yc, 0, h};
  Point(5) = {xc, yc - R, 0, h};
  Circle(1) = {2,1,3};
  Circle(2) = {3,1,4};
  Circle(3) = {4,1,5};
  Circle(4) = {5,1,2};
  Curve Loop(1) = {1,2,3,4};   	// Boundary
  Plane Surface(1) = {1};     	// Surface
  Physical Surface(1) = {1};  	// Physical Tag