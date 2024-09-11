function [geo2] = supercell(geo1, array)
%SUPERCELL Create a supercell by replicating a geometry.
%   geometry2 = SUPERCELL(geometry1,array) generates a new geometry that is
%   an array(1) x array(2) x array(3) supercell of geometry1.
%
%   See also IMPORT_POSCAR.

    geo2 = geo1;
    geo2.coords = [];
    
    for i = 1:numel(geo1.atomcount)
        for a1 = -(array(1)-1)/2:(array(1)-1)/2
            for a2 = -(array(2)-1)/2:(array(2)-1)/2
                for a3 = -(array(3)-1)/2:(array(3)-1)/2
                    start = sum(geo1.atomcount(1:i-1)) + 1;
                    geo2.coords = [geo2.coords; geo1.coords(start:start+geo1.atomcount(i)-1,:) + ...
                                   repmat([a1 a2 a3], geo1.atomcount(i), 1)];
                end
            end
        end        
    end
    
    geo2.atomcount = geo1.atomcount * prod(array);
    
    for i = 1:3
        geo2.coords(:,i) = mod(geo2.coords(:,i) / array(i), 1);
        geo2.lattice(i,:) = geo2.lattice(i,:) * array(i);
    end
    
    % Check if there is an atom at the origin
    tol = 1e-6; % tolerance for floating-point comparison
    origin_exists = any(all(abs(geo2.coords) < tol, 2));
    
    if ~origin_exists
        % If no atom at the origin, translate the coordinates to place the
        % first atom at the origin
        translation = geo2.coords(1, :);
        geo2.coords = geo2.coords - translation;
        
        % Ensure all coordinates remain in the range [0, 1)
        geo2.coords = mod(geo2.coords, 1);
    end
end
