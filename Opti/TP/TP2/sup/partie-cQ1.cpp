/*-------------------------------------------------------------------------
 Author: Hacene Ouzia (hacene.ouzia@lip6.fr)

 (c) Copyright 2017 Universite Paris 6

 This software is licensed under the Common Public License. Please see
 accompanying file for terms.
---------------------------------------------------------------------------*/

#include <iostream>
#include <sstream>
#include <iomanip>
#include "CoinFloatEqual.hpp"
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
        // on a ici un minimum
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

		// Ajout de la coupe pour rendre le probleme broné



		OSI_SOLVER->loadProblem(MATRIX,COL_LB,COL_UB,OBJECTIVE,ROW_LB,ROW_UB);
		CoinPackedVector row3;
		row3.insert(0,1);row3.insert(1,2);
		// borne de la contrainte
		OSI_SOLVER->addRow(row3,-OSI_SOLVER->getInfinity(),7);

		CoinPackedVector row4;
		row4.insert(0,2);row4.insert(1,3);
		// borne de la contrainte
		OSI_SOLVER->addRow(row4,-OSI_SOLVER->getInfinity(),11);
		//--
        //-- Resoudre le probleme
        //--
		OSI_SOLVER->initialSolve();

		if ( OSI_SOLVER->isProvenOptimal() )
		{
			std::cout << std::endl << "     Solution status : optimal";
			std::cout << std::endl << "     Objective value : " << OSI_SOLVER->getObjValue() << std::endl;

		}
		else
		{
			std::cout << std::endl << "There is no solution, have a good day!" << std::endl << std::endl;
		}

		//--
		//-- Recuperer la solution ...
		const double * SOLUTION = OSI_SOLVER->getColSolution();

		CoinAbsFltEq Equal;

		std::cout << "     Solution (non zero values only):" << std::endl << std::endl;
		for(unsigned int j=0; j<NBR_VARS; ++j)
		{
			const double value = SOLUTION[j];

			if(!Equal(value,0))
			{
				std::ostringstream oss; oss << j;
				std::string var_name("x" + oss.str());

				printf("       %8s   =  %3.2f \n", var_name.c_str(), value);
			}
		}

		//--
        //-- Nettoyage ...
        //--
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
