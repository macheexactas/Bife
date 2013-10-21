%This class represents a PE (or block)
%Each block computes an element of the similarity matrix.
classdef SWPEAlgorithm
   properties
      alpha;
      beta;
      sigma_table;
      sigma_order;
      s_out;
      t_out;
      max_out;
      v_out;
      f_out;
      e;
      f;
      v_sigma;
      maxEF;
      S1;
      S2;
      T1;
      T2;
      V1;
      V2;
      V3;
      V4;
      V5;
      V6;
      M1;
      M2;
      E1;
      E2;
      E3;
      E4;
      F1;
      F2;
   end
   
   methods
       %Constructor: returns object
       %  It receives
       %  alpha = gap open
       %  beta = gap extension
       %  sigma = matrix within the LUT
       %  s_order = order of the elements in sigma. String's chain
       function sW = SWPEAlgorithm(alpha,beta,sigma_table,s_order)
            if  nargin > 0
               sW.alpha = alpha;
               sW.beta = beta;
               sW.sigma_table = sigma_table;
               sW.sigma_order = s_order;
            end
       end
       
       function sW = restart(sW, s_in, t_in, v_in, max_in, v_in_alpha, f_in)
           sW.S1 = s_in;
           sW.S2 = '';
           sW.T1 = t_in;
           sW.T2 = '';
           sW.V1 = v_in;
           sW.V2 = 0;
           sW.V3 = 0;
           sW.V4 = 0;
           sW.V5 = 0;
           sW.V6 = 0;
           sW.M1 = max_in;
           sW.M2 = 0;
           sW.E1 = max(-sW.beta,-sW.alpha);
           sW.E2 = 0;
           sW.E3 = 0;
           sW.E4 = 0;
           sW.F1 = max(v_in_alpha, (f_in-sW.beta));
           sW.F2 = 0;
           
           %updateInterestingValues
           sW.s_out = sW.S2;
           sW.t_out = sW.T2;
           sW.max_out = sW.M2;
           sW.v_out = sW.V6;
           sW.f_out = sW.F2;
           sW.e = sW.E1;
           sW.f = sW.F1;
           sW.v_sigma = sW.V3;
           sW.maxEF = sW.E3;
           
           %Show Results
           %sW
       end
       
       
       % Receives the input from the other PE and computes all internal and external values
       % S & T --> Character of input sequences
       % v_in --> V(i-1,j-1)
       % f_in --> F(i-1,j)
       function sW = runOneClock(sW, s_in, t_in, v_in, max_in, v_in_alpha, f_in)
           %Update in order
           sW.S2 = sW.S1;
           sW.S1 = s_in;
           
           sW.T2 = sW.T1;
           sW.T1 = t_in;
           
           sW.M2 = sW.M1;
           sW.V6 = sW.V5;
           sW.E4 = sW.E3;
           sW.E2 = sW.E1;
           sW.E1 = max(sW.E2-sW.beta, sW.V6-sW.alpha);
           
           sW.F2 = sW.F1;
           sW.E3 = max(sW.E2, sW.F2);
           
           sW.V4 = sW.V3;
           sW.V2 = sW.V1;
           sW.V1 = v_in;
           
           sigma = calcSigma(sW);
           sW.V3 = sW.V2 + sigma;
           sW.M2 = sW.M1;
           sW.V5 = max(sW.V4, sW.E4);
           sW.M1 = max(max_in, sW.V6);
           sW.F1 = max(v_in_alpha, f_in);
           
           sW.s_out = sW.S2;
           sW.t_out = sW.T2;
           sW.max_out = sW.M2;
           sW.v_out = sW.V6;
           sW.f_out = sW.F2;
           sW.e = sW.E1;
           sW.f = sW.F1;
           sW.v_sigma = sW.V3;
           sW.maxEF = sW.E3;
           
           %Show Results
           sW
       end
       
       function sigma = calcSigma(sW)
           % calculate sigma -->  s(S[i],T[j])
               sigma = sW.sigma_table(1);       % TO DO. Use sW.S2 and sW.T1 for the index
       end
           
           
   end
end