h = 1;                     // Characteristic length of a mesh element
    Point(1) = {0, 0, 0, h};   // Point construction
    Point(2) = {10, 0, 0, h};
    Point(3) = {10, 10, 0, h};
    Point(4) = {0, 10, 0, h};
    Line(1) = {1,2};            //Lines
    Line(2) = {2,3};
    Line(3) = {3,4};
    Line(4) = {4,1};
    Curve Loop(1) = {1,2,3,4};   // A Boundary
    Plane Surface(1) = {1};     // A Surface

    Extrude {0, 0, 10} { Surface{1};}  // Extrusion!
    Physical Volume(1) = {1};          // Setting a label to the Volume