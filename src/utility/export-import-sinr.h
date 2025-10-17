#ifndef EXPORT_IMPORT_SINR_H
#define EXPORT_IMPORT_SINR_H

#include <fstream>
#include <iostream>
#include <filesystem>
#include <chrono>
#include <thread>
#include <string>
#include <cstdio>
#include <cmath>

void ExportSinr(double sinr, int nodeId, int rbIndex, double timestamp)
{
    const std::string filename = "sinr_data.txt";

    std::ofstream outf{filename, std::ios::app};

    if (timestamp != 9.999){ // Se mudar duração de simulação alterar aqui tbm!!
        if (outf) {
            outf << nodeId 
            << ", " << rbIndex 
            << ", " << sinr 
            << ", " << timestamp << std::endl;
            outf.close();
        } 
        else {
            std::cerr << "Could not open: " << filename << std::endl;
        }
    }
    else{
        std::remove(filename.c_str());  
    }
}

const double value_tolerance = 1e-6; 

double ImportSinr ()
{
    const std::string filename = "predicted_sinr.txt";
    static double lastReadSinr = 0.0;
    const int maxFileChecks = 20;    
    const int fileCheckInterval = 100; // Ms
    
    for (int i = 0; i < maxFileChecks; ++i) 
    { 
        double currentSinr = 0.0;
        std::ifstream inf{filename};
        if (inf.is_open()) 
        {
            inf >> currentSinr;
            if(std::abs(currentSinr - lastReadSinr) > value_tolerance)
            {
                lastReadSinr = currentSinr;
                std::remove(filename.c_str());
                return currentSinr;
            }
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(fileCheckInterval));
    }
    std::cerr << "Simulator could not locate new predicted SINR value in:" << filename << endl;
    return -1.0;
}

#endif /* EXPORT_IMPORT_SINR_H */
