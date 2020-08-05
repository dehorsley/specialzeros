function tests = specialzerosTests
tests = functiontests(localfunctions);
end

function testBesscrosszero(testCase)
    BCs = ['DD'; 'DN'; 'ND'; 'NN'];
    for nu = [0, 1e-5, logspace(0,2,10)]
        for l = logspace(0,2,10) + 0.01
            for i = 1:size(BCs,1)
                for n = 1:400
                    failed = false;
                    % sprintf('nu = %e, l = %e, BC = %s, n = %d', nu, l, BCs(i,:), n)
                    % log(testCase, sprintf('nu = %e, l = %e, BC = %s, n = 1:400', nu, l, BCs(i,:)));
                    try
                        besscrosszero(nu, l, n, BCs(i,:), 1e-13);
                    catch ME
                        failed = true;
                    end
                    verifyFalse(testCase, failed, sprintf('nu = %e, l = %e, BC = %s, n = %d', nu, l, BCs(i,:), n))

                end
            end
        end
    end
end 

function testBesscrosszeroError(testCase)
    verifyLessThanOrEqual(testCase, abs(besscrosszero(0, 2, 1, 'DD')-3.123030919595692),eps);
    verifyLessThanOrEqual(testCase, abs(besscrosszero(0, 2, 1, 'DN')-1.794010904758688),eps);
    verifyLessThanOrEqual(testCase, abs(besscrosszero(0, 2, 1, 'ND')-1.360777385337008),eps);
    verifyLessThanOrEqual(testCase, abs(besscrosszero(0, 2, 1, 'NN')-3.196578380810634),eps);

    verifyError(testCase, @() besscrosszero(0, 2, 1, 'AA'), 'besscrosszero:invalidArgument');
    verifyError(testCase, @() besscrosszero(0, 2, 1, 'A'), 'besscrosszero:invalidArgument');
    verifyError(testCase, @() besscrosszero(0, 2, 1, 'NNN'), 'besscrosszero:invalidArgument');

end


% function testBesscrosszero(testCase)
%     t = besscrosszeroTests;
%     for i = 1:length(t)
%         [k, itter, errs] = besscrosszero(
%             t(i).nu, 
%             t(i).l, 
%             t(i).N, t(i).BC)
%         verifyLessThanOrEqual(testCase,k-t.expected,t(i).tol)
%     end
% end 
