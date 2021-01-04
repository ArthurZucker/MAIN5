/*-------------------------------------------------------------------------
 Author: Hacene Ouzia (hacene.ouzia@lip6.fr)

 (c) Copyright 2017 Universite Paris 6

 This software is licensed under the Common Public License. Please see 
 accompanying file for terms.
---------------------------------------------------------------------------*/

#include <iostream>
#include <sstream>
#include <string>
#include <time.h>

//--
//-- Classes Coin-or
//--
#include "CoinTime.hpp"
#include "CoinFloatEqual.hpp"

#include "OsiClpSolverInterface.hpp"
#include "CbcModel.hpp"

using namespace std;


template<typename T> T from_string(const std::string & Str)
{
	T Dest;
	
    // cr�er un flux � partir de la cha�ne donn�e
    std::istringstream iss( Str );
    
    // tenter la conversion vers Dest
    if(iss >> Dest != 0)
    	return Dest;
    else 
    	return 0;
}

template<typename T> std::string to_string(const T & Value)
{
	// Out stream to build the string 
	std::ostringstream oss;

	// Write the value on the stream
	oss << Value;

	return oss.str();
}

int main(int argc, char* argv[])
{	
	try
	{
        
        //---
        //--- PARTIE B
        //---
        
		//--
        //-- Charger le probleme a partir d'un fichier MPS (format IBM...)
		std::string prob_name(argv[1]);
        
		
        //--
        //-- Le solver par defaut OsiClp
        OsiClpSolverInterface OSI_SOLVER;

        CbcModel CBCMODEL(OSI_SOLVER);
        
        CBCMODEL.solver()->readMps(prob_name.c_str());
        CBCMODEL.solver()->setObjSense(1);
        CBCMODEL.setLogLevel(3);
        
		//--
        //-- Resoudre la relaxation continue ...
		std::cout << std::endl << " + Resoudre la relaxation continue ... " << std::endl << std::endl;
		
        CBCMODEL.initialSolve();
        CoinAbsFltEq Equal2;
        const double * SOLUTION2 = CBCMODEL.solver()->getColSolution();
        const unsigned int NBR_VARS2 = CBCMODEL.getNumCols();
        for(unsigned int j=0; j<NBR_VARS2; ++j)
        {
            const double value2 = SOLUTION2[j];
            
            if(!Equal2(value2,0))
            {
                std::ostringstream oss; oss << j;
                std::string var_name("x" + oss.str());
                
                printf("       %8s   =  %3.2f \n", var_name.c_str(), value2);
            }
        }
        
        std::cout << std::endl;
		//--
        //-- Recuperer la solution optimale ...
		if ( CBCMODEL.solver()->isProvenOptimal() )
		{ 
			std::cout << std::endl << "Status : Optimal solution" << std::endl; 
			std::cout << std::endl << " Objective value = " << CBCMODEL.solver()->getObjValue() << std::endl;
		}
		else
		{
			std::cout << std::endl << "Pas de solution ... " << std::endl << std::endl;
		}

		//--
        //-- Resoudre le probleme en nombres entiers
        std::cout << std::endl << " + Do a complete search with OsiSolverInterface . . . " << std::endl << std::endl;
		
		//--
        //-- Quelques indications avant de resoudre le probleme ...
		CBCMODEL.solver()->setHintParam(OsiDoReducePrint,true);
       
        CBCMODEL.branchAndBound();
		
        //--
        //-- Best solution ...
        const double * SOLUTION = CBCMODEL.solver()->getColSolution();
        
        CoinAbsFltEq Equal;
        
        std::cout << "  + Best solution (valeurs non nulles seulement):" << std::endl << std::endl;
        
        const unsigned int NBR_VARS = CBCMODEL.getNumCols();
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
