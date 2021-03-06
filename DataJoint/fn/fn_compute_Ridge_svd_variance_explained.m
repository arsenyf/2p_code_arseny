function [variance_explained] = fn_compute_Ridge_svd_variance_explained(Vc,Vm,U)
%short code to compute the correlation between lowD data Vc and modeled
%lowD data Vm. Vc and Vm are temporal components, U is the spatial
%components. corrMat is a the correlation between Vc and Vm in each pixel.
Vc=Vc';
Vm=Vm';

covVc = cov(Vc');  % S x S
covVm = cov(Vm');  % S x S
cCovV = bsxfun(@minus, Vm, mean(Vm,2)) * Vc' / (size(Vc, 2) - 1);  % S x S
covP = sum((U * cCovV) .* U, 2)';  % 1 x P
varP1 = sum((U * covVc) .* U, 2)';  % 1 x P
varP2 = sum((U * covVm) .* U, 2)';  % 1 x P
stdPxPy = varP1 .^ 0.5 .* varP2 .^ 0.5; % 1 x P
variance_explained = (gather((covP ./ stdPxPy)')).^2;