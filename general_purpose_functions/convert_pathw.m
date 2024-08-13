% path_string = convert_pathw(path_string)
%
% Change a path in linux format to the windows format
%
% INPUT:
% path_string = a path string to be converted
%
% OUTPUT:
% path_string = the same string, now in the compatible format
%
% Author: Paulo Roberto Cabral Passos  Date: 13/08/2024


function path_string = convert_pathw(path_string)
    for a = 1: length(path_string)
       if strcmp(path_string(a),'\')
          path_string(a) = '/';
       end
    end
end