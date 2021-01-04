/*-------------------------------------------------------------------------
 Author: Hacene Ouzia (hacene.ouzia@lip6.fr)

 (c) Copyright 2017 Universite Paris 6

 This software is licensed under the Common Public License. Please see 
 accompanying file for terms.
---------------------------------------------------------------------------*/

#include <iostream>
#include <sstream>
#include <iomanip>

#include "CoinPackedVector.hpp"
#include "CoinPackedMatrix.hpp"

#include "OsiClpSolverInterface.hpp"

using namespace std;

int main(int argc, char* argv[])
{	
	try
	{
        
		
		/* -------------------------
		 * Exemple traite :
		 * 
		 * 		Max 3x + y
		 *       s.t.
		 * 		 -2x + y <= 0
		 *         x -2y <= 0
		 * 		   x, y >= 0
		 *--------------------------*/


        const unsigned int NBR_VARS = 2;
        const unsigned int NBR_ROWS = 2;
        
		OsiClpSolverInterface * OSI_SOLVER = new OsiClpSolverInterface();

		//--
        //-- Construction du probleme ...

        //
		//-- Fonction obectif ...
        //
        OSI_SOLVER->setObjSense(-1.);
        
		double * OBJECTIVE = new double[2];
		OBJECTIVE[0] = 3; OBJECTIVE[1] = 1;

		//
        //-- Matrice des contraintes ...
        //
		CoinPackedMatrix MATRIX;

		MATRIX.setDimensions(0,NBR_VARS);

		CoinPackedVector row1, row2;
		row1.insert(0,-2);row1.insert(1,1);
		row2.insert(0,1);row2.insert(1,-2);

		MATRIX.appendRow(row1);
		MATRIX.appendRow(row2);    	

		double * ROW_LB = new double[ NBR_ROWS ];
		double * ROW_UB = new double[ NBR_ROWS ];

		//
        //-- Les seconds membres ...
        //
		for(unsigned int i=0; i<NBR_ROWS; ++i) ROW_UB[i] = 0.;

		for(unsigned int i=0; i<NBR_ROWS; ++i) ROW_LB[i] = - OSI_SOLVER->getInfinity();
 

		//
        //-- Bornes des variables ...

		double * COL_UB    = new double[NBR_VARS];
		double * COL_LB    = new double[NBR_VARS];

		for(unsigned int i=0; i<NBR_VARS; ++i)
		{
			COL_LB[i] = 0;
			COL_UB[i] = OSI_SOLVER->getInfinity();
		}

		OSI_SOLVER->loadProblem(MATRIX,COL_LB,COL_UB,OBJECTIVE,ROW_LB,ROW_UB);

		//--
        //-- Resoudre le probleme
        //--
		OSI_SOLVER->initialSolve();

		if(OSI_SOLVER->isProvenDualInfeasible())
		{
            //
            //-- Recuperer le rayon extreme : version 1...
            //
			std::cout << std::endl <<" + The problem is unbounded, because the dual is infeasible"<< std::endl;

			printf("\n+ COIN PRIMAL RAY . . . \n\n");
			printf("   %5s       %9s\n","index","value");
			printf("   ---------------------\n");

			vector<double *> rays = OSI_SOLVER->getPrimalRays(2);

			double * ray = rays.at(0);

			for(unsigned int i=0; i<NBR_VARS; ++i)
			{
				printf("   %5u       %9.5g\n",i,ray[i]);
			}  		  		
		}  

		//
        //-- Recuperons un rayon extreme autrement ...
        //
        
        //--
        //-- Premier point ...
        //--
		std::cout << std::endl <<" + ADD THE NEW CONSTRAINT: OBJECTIVE_VALUE <= BIG_VALUE "<< std::endl << std::endl;

		const double BIG_VALUE = 100;

		CoinPackedVector row;
		
		row.insert(0,OBJECTIVE[0]);row.insert(1,OBJECTIVE[1]);

		int * index_lastRow = new int[1];
		index_lastRow[0] = OSI_SOLVER->getNumRows();
		OSI_SOLVER->addRow(row,-OSI_SOLVER->getInfinity(),BIG_VALUE);
        
        //
        //-- Warmstart ...
        //
		OSI_SOLVER->resolve();
		
				
		double * SAVED_RAY = new double [NBR_VARS];

		const double * solution = OSI_SOLVER->getColSolution();

		printf("\n+ EXTREM RAY ONE ....\n\n");
		printf("   %5s       %9s\n","index","value");
		printf("   ---------------------\n");

		for(unsigned int i=0; i<NBR_VARS; ++i)
		{
			printf("   %5u       %9.5g\n",i,solution[i]);
			
			SAVED_RAY[i] = solution[i];
		}


		OSI_SOLVER->deleteRows(1,index_lastRow);
        
        //--
        //-- Second point ...
        //--
		std::cout<< std::endl << "+ ADD ANOTHER CONSTRAINT "<< std::endl <<endl;
		CoinPackedVector row_two;
		row_two.insert(0,OBJECTIVE[0]);row_two.insert(1,OBJECTIVE[1]);
		OSI_SOLVER->addRow(row_two,-OSI_SOLVER->getInfinity(),2*BIG_VALUE);
		OSI_SOLVER->resolve();

		const double * solution_two = OSI_SOLVER->getColSolution();

		printf("\n+ EXTREME RAY TWO . . . \n\n");
		printf("   %5s       %9s\n","index","value");
		printf("   ---------------------\n");

		for(unsigned int i=0; i<NBR_VARS; ++i)
		{
			printf("   %5u       %9.5g\n",i,solution_two[i]);
			
			SAVED_RAY[i] = solution_two[i] - SAVED_RAY[i];
		}  	

		//--
        //-- Enfin le rayon extreme ..
        //--
		printf("\n+ AN EXTREME RAY . . . \n\n");
		printf("   %5s       %9s\n","index","value");
		printf("   ---------------------\n");

		for(unsigned int i=0; i<NBR_VARS; ++i)
		{
			std::cout << std::setw(3) << " " << std::setw(5) << i << std::setw(5) << " " << std::setw(9) << SAVED_RAY[i] << std::endl;
		}

		//--
        //-- Nettoyage ...
        //--
		if(SAVED_RAY != NULL){delete[] SAVED_RAY; SAVED_RAY =NULL;}
		if(index_lastRow != NULL){delete[] index_lastRow; index_lastRow = NULL;}
		if(COL_UB != NULL){delete[] COL_UB; COL_UB = NULL;}
		if(COL_LB != NULL){delete[] COL_LB; COL_LB = NULL;}
		if(ROW_UB != NULL){delete[] ROW_UB; ROW_UB = NULL;}
		if(ROW_LB != NULL){delete[] ROW_LB; ROW_LB = NULL;} 
		if(OBJECTIVE != NULL){delete[] OBJECTIVE; OBJECTIVE = NULL;} 
		if(OSI_SOLVER != NULL){delete OSI_SOLVER; OSI_SOLVER = NULL;}
		
		
	}//END TRY
	catch(CoinError & ex)
	{  	
		cerr << "\nException : " << ex.message() << std::endl <<std::endl
		<< "   --> from method : " << ex.methodName() << std::endl
		<< "   --> from class  : " << ex.className() << std::endl; 
	}
	catch(exception & e)
	{
		cerr << "\nException : " << e.what() << std::endl << std::endl;
	}

	return 0;	
}
