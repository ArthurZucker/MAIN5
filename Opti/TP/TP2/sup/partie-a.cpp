/*-------------------------------------------------------------------------
 Author: Hacene Ouzia (hacene.ouzia@lip6.fr)

 (c) Copyright 2017 Universite Paris 6

 This software is licensed under the Common Public License. Please see 
 accompanying file for terms.
---------------------------------------------------------------------------*/


#include <iostream>
#include <sstream>
#include <time.h>

//--
//-- Classes Coin ...
#include "CoinPackedVector.hpp"
#include "CoinPackedMatrix.hpp"
#include "CoinTime.hpp"

#include "OsiClpSolverInterface.hpp"

#include "CoinFloatEqual.hpp"
#include "CoinTime.hpp"

using namespace std;


int main(int argc, char* argv[])
{
    try
	{
		
		//--
        //-- Partie A : resoudre a l'aide de OsiClp une instance d'un probleme
        //-- d'optimisation lineaire en variables entiers ...
        const unsigned int        NBR_VARS = 20;
        const unsigned int        NBR_ROWS = 10;
		const double       TIGHTNESS_RATIO = 0.25;


        //--
        //-- Solver OsiClp ...
        OsiClpSolverInterface OSI_SOLVER;
        
		//--
		//-- Instance aléatoire ...
        //--
        
        //--
        //-- Matrice des contraintes ...
		srand(NBR_VARS*NBR_ROWS);
		
		const unsigned int MaxMatrixEntrees = 1000;
		const unsigned int MinMatrixEntrees = 0;

		CoinPackedMatrix MATRIX;
		
		MATRIX.setDimensions(0,NBR_VARS);

		for(unsigned int i=0; i<NBR_ROWS; ++i)
		{
			CoinPackedVector row;
			
			for(unsigned int j=0; j<NBR_VARS; ++j)
			{
				const unsigned int value = (unsigned int) (MinMatrixEntrees + rand()%MaxMatrixEntrees);
				row.insert(j,value);
			}
			
			MATRIX.appendRow(row);
		}

		//--
        //-- Fonction objectif ...
		double * OBJECTIVE = new double [NBR_VARS];

		for(unsigned int j=0; j<NBR_VARS; ++j)
		{
			double col_capacity = 0;

			for(unsigned int i=0; i<NBR_ROWS; ++i)
			{
				col_capacity += MATRIX.getCoefficient(i,j);
			}

			const double value = col_capacity/NBR_ROWS + 500/(rand() + 1);

			OBJECTIVE[j] = value;
		}

 
		//--
        //-- Second membre ...
		double * ROW_UB = new double[NBR_ROWS];

		for(unsigned int i=0; i<NBR_ROWS; ++i)
		{

			double row_capacity = 0;

			for(unsigned int j=0; j<NBR_VARS; ++j)
			{
				row_capacity += MATRIX.getCoefficient(i,j);
			}

			const double value = TIGHTNESS_RATIO * row_capacity;

			ROW_UB[i] = value;
			
		}
		
		double * ROW_LB = new double[NBR_ROWS];
		
		for(unsigned int i=0; i<NBR_ROWS; ++i)
		{
			ROW_LB[i] = - OSI_SOLVER.getInfinity();
		}
		

		//--
        //-- Bornes des variables ...
		//--

		double * COL_UB    = new double[NBR_VARS];
		double * COL_LB    = new double[NBR_VARS];

		for(unsigned int i=0; i<NBR_VARS; ++i)
		{
			COL_LB[i] = 0;
			COL_UB[i] = 1; 
		}
		
		
        //--
        //-- Charger le probleme ...
		OSI_SOLVER.loadProblem(MATRIX,COL_LB,COL_UB,OBJECTIVE,ROW_LB,ROW_UB);
		
        //--
        //-- Indiquer des paramètres ...
		OSI_SOLVER.setIntParam(OsiNameDiscipline,2); //--- A quoi cela sert-il ?
		std::string PROBNAME("MKnapsack");
		OSI_SOLVER.setStrParam(OsiProbName,"Name");
		
		//--
        //-- Nom des variables ...
		for(unsigned int j=0; j<NBR_VARS; ++j)
		{
			std::string var_name("x(" + to_string(j+1) + ")");

			OSI_SOLVER.setColName(j,var_name);
		}
		
		//--
        //-- Nom des lignes ...
		for(unsigned int i=0; i<NBR_ROWS; ++i)
		{
			std::string row_name("row-" + to_string(i+1));
			OSI_SOLVER.setRowName(i,row_name);
		}
		
		//--
        //-- Nom de la fonction objectif ...
		std::string obj_name("Obj");
		
		OSI_SOLVER.setObjName(obj_name);
		OSI_SOLVER.writeMps("MKnapsack");
    

		//--
        //-- Sens de l'optimisation MAX=-1, MIN=1
		OSI_SOLVER.setObjSense(-1.);
		
 		
		//--
        //-- La relaxation continue ...
        OSI_SOLVER.initialSolve();
		
        //--
        //-- On peut résoudre des MIP avec OsiClp mais Cbc lui est preferable ...
        for(unsigned int j=0; j<NBR_VARS; ++j)
		{
			OSI_SOLVER.setInteger(j);
		}
		
        
		CoinTimer Timer;
		Timer.reset();
		
        //--
        //-- Un petit B&B ...
		OSI_SOLVER.branchAndBound();
		
		const double BAB_TIME = Timer.timeElapsed();

        //--
        //-- Quelques logs ...
		if ( OSI_SOLVER.isProvenOptimal() )
		{ 
			std::cout << std::endl << "     Solution status : optimal"; 
			std::cout << std::endl << "     Objective value : " << OSI_SOLVER.getObjValue() << std::endl;
			std::cout << std::endl << "        Elapsed time : " << BAB_TIME << std::endl << std::endl;
		}
		else
		{
			std::cout << std::endl << "There is no solution, have a good day!" << std::endl << std::endl;
		}
		
		//--
		//-- Recuperer la solution ...
		const double * SOLUTION = OSI_SOLVER.getColSolution();
		
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
		
		std::cout << std::endl;

		//--
        //-- Nettoyage ...
		if(COL_UB != NULL){delete[] COL_UB; COL_UB = NULL;}
		if(COL_LB != NULL){delete[] COL_LB; COL_LB = NULL;}
		if(ROW_UB != NULL){delete[] ROW_UB; ROW_UB = NULL;}
		if(ROW_LB != NULL){delete[] ROW_LB; ROW_LB = NULL;} 
		if(OBJECTIVE != NULL){delete[] OBJECTIVE; OBJECTIVE = NULL;} 
				
	}
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
