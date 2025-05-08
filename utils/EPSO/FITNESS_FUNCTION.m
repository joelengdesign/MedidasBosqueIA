function [ fit ] = FITNESS_FUNCTION( popSize, pos )
% Computes fitness fot the whole population
% Optimization functions can be obtained from: http://infinity77.net/global_optimization/index.html
global ff_par;
fit = zeros( 1, popSize );
for i = 1 : popSize
    switch ff_par.ff
        case 1
            % Sphere function
            fit( i ) = pos( i, : ) * pos( i, : )';
        case 2
            % Rosenbrock function
            fit( i ) = 0;
            for j = 1 : ff_par.D - 1
                term1 = pos( i, j + 1 ) - pos( i, j )^2;
                term2 = 1 - pos( i, j );
                fit( i ) = fit( i ) + 100 * term1^2 + term2^2;
            end
        case 3
            % Shaffer 1 function
            fit( i ) = 0;
            for j = 1 : ff_par.D - 1
               term = pos( i, j + 1 ) * pos( i, j + 1 ) + pos( i, j ) * pos( i, j );
               fit( i ) = fit( i ) + ( sin( sqrt( term ) )^2 - 0.5 ) / ( 0.001 * term + 1 )^2 + 0.5;
            end
        case 4
            % Schwefel function
            fit( i ) = 0;
            for j = 1 : ff_par.D
                x = pos( i, j );
                fit( i ) = fit( i ) + x * sin( sqrt( abs( x ) ) );
            end
            fit( i ) = 418.9829 * ff_par.D - fit( i );
        case 5
            % Griewank function
            term1 = 0;
            term2 = 1;
            for j = 1 : ff_par.D
                x = pos( i, j );
                term1 = term1 + x^2;
                term2 = term2 * cos( x / sqrt( j ) );
            end
            fit( i ) = 1 + term1 / 4000 - term2;
        case 6
            % Rastrigin function
            fit( i ) = 0;
            for j = 1 : ff_par.D
                x = pos( i, j );
                fit( i ) = fit( i ) + x^2 - 10 * cos( 2 * pi * x );
            end
            fit( i ) = 10 * ff_par.D + fit( i ) ;
        case 7
            % Ackley function
            term1 = 0;
            term2 = 0;
            for j = 1 : ff_par.D
                x = pos( i, j );
                term1 = term1 + x^2;
                term2 = term2 + cos( 2 * pi * x );
            end
            fit( i ) = 20 - 20 * exp( -0.2 * sqrt( ( term1 / ff_par.D ) ) ) + exp( 1 ) - exp( term2 / ff_par.D );
        otherwise
            % This is never supposed to happen
    end
    ff_par.fitEval = ff_par.fitEval + 1;
    ff_par.memNumFitEval( ff_par.fitEval ) = ff_par.fitEval;
    if ff_par.fitEval == 1
        ff_par.bestFitEval = fit( i );
        ff_par.memFitEval( ff_par.fitEval ) = ff_par.bestFitEval;
    else
        if fit( i ) < ff_par.bestFitEval
            ff_par.bestFitEval = fit( i );
        end
        ff_par.memFitEval( ff_par.fitEval ) = ff_par.bestFitEval;
    end
end
end