#include <iostream>
#include <fstream>
#include <string>
#include <vector>
class ut {
public:
  static std::vector<std::string> explode(const std::string& str, const char& ch) {
    std::string next;
    std::vector<std::string> result;
    for (std::string::const_iterator it = str.begin(); it != str.end(); it++) {
        if (*it == ch) {
            if (!next.empty()) {
                result.push_back(next);
                next.clear();
            }
        } else {
            next += *it;
        }
    }
    if (!next.empty())
         result.push_back(next);
    return result;
  };
  static std::string trim(std::string& str)
  {
    std::size_t first = str.find_first_not_of(' ');
    std::size_t last = str.find_last_not_of(' ');
    return str.substr(first, (last-first+1));
  }
};
int main (int argc, char* argv[]) {
  if(argc == 1) {std::cout << "No property or file provided."; return 1;}
  std::string line;
  std::ifstream conffile (argv[2]);
  if (conffile.is_open())
  {
    while ( std::getline (conffile,line) )
    {
      if(line.at(0) != '#') {
        if(line.find(argv[1]) == 0) {
          std::cout << ut::trim(ut::explode(line, '=')[1]);
        }
      }
    }
    conffile.close();
  }
  else std::cout << "Unable to open file. Maybe insufficient permissions?"; 
  return 0;
}
