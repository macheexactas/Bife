%This class simulates the PE's cascade working together
classdef Cascading
   properties
      blocks;
      cant_blocks;
      active;       % active(k) indicates if the k block is working at this step
      max_active;
      seq_S;
      seq_T;
      col;          % col(k) indicates the column where is working the block k
      row;          % row(k) indicates the row where is working the block k
      V;
      E;
      F;
      alpha;
      beta;
      s_in;
      t_in;
      max_in;
      v_in;
      v_in_alpha;
      f_in;
   end
       
   methods
       %Constructor: returns object
       %  It receives
       %  n = cant. of blocks that will be work in parallel
       %  alpha = gap open
       %  beta = gap extension
       %  sigma = matrix within the LUT
       %  s_order = order of sigma. String's chain
       %  sequences S & T
       function Cascade = Cascading(n, alpha, beta, sigma, s_order, S, T)
            if  nargin > 0
                import src.*
                Cascade.blocks = SWPEAlgorithm; %type inicialization.
                Cascade.cant_blocks = n;
                for b=1:n
                    Cascade.blocks(b) = SWPEAlgorithm(alpha, beta, sigma, s_order);
                end
                Cascade.seq_S = S;
                Cascade.seq_T = T;
                Cascade.alpha = alpha;
                Cascade.beta = beta;
            end
       end
       
       % It computes n lines from the beginning
       % Receives:
       %   Cascade --> Self (matlab's bussines)
       function C = run_n_Steps(C, n)
           %inicialize the sistem
           i = C.cant_blocks;
           for k = 1:i
               C.active(k) = 0;
               C.col(k) = k+1;
               C.row(k) = 2;
           end
           C.active(1) = 1;
           C.max_active = 1;
           
           % inicialize matrix
           rows = size(C.seq_T);
           cols = size(C.seq_S);
           C.V = zeros(rows(2),cols(2));
           C.E = zeros(rows(2),cols(2));
           C.F = zeros(rows(2),cols(2));
           
           %inicialize input's arrays
           C.s_in = '';
           C.t_in = '';
           C.max_in = zeros(1,C.cant_blocks);
           C.v_in = zeros(1,C.cant_blocks);
           C.v_in_alpha = zeros(1,C.cant_blocks);
           C.f_in = zeros(1,C.cant_blocks);
           
           %inicialize parameters for block 1
           C.s_in(1) = C.seq_S(C.col(1));
           C.t_in(1) = C.seq_T(C.row(1));
           C.max_in(1) = 0;
           C.v_in(1) = 0;
           C.v_in_alpha(1) = C.v_in(1) - C.alpha;
           C.f_in(1) = 0;
           
           %start running
           C.blocks(1) = C.blocks(1).restart(C.s_in(1), C.t_in(1), C.v_in(1), C.max_in(1), C.v_in_alpha(1), C.f_in(1));
           % we run the first clock
           C.blocks(1) = C.blocks(1).runOneClock(C.s_in(1), C.t_in(1), C.v_in(1), C.max_in(1), C.v_in_alpha(1), C.f_in(1));
           
           % now we calculate the E(i,j) and F(i,j)
           Eij= C.blocks(1).E1;
           Fij= C.blocks(1).F2;
           
           % we run the second clock
           C.blocks(1) = C.blocks(1).runOneClock(C.s_in(1), C.t_in(1), C.v_in(1), C.max_in(1), C.v_in_alpha(1), C.f_in(1));
           
           % we run the third clock
           C.blocks(1) = C.blocks(1).runOneClock(C.s_in(1), C.t_in(1), C.v_in(1), C.max_in(1), C.v_in_alpha(1), C.f_in(1));
           
           % Update the 3 Matrix
           V(C.row(1),C.col(1)) = C.blocks(1).V6;
           E(C.row(1),C.col(1)) = Eij;
           F(C.row(1),C.col(1)) = Fij;
           
           % Jump one row  --> Verify jump of column --> TODO
           tmp = C.row(1);
           C.row(1) = tmp +1;
           
           %second block:
           
           
           %Show Results
           C
           C.blocks(1)
           V
           E
           F
           
       end
       
   end
end