#include <iostream>
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
};
int main (int argc, char* argv[]) {
  if(argc == 1) {std::cout << "No property provided."; return 1;}
  std::vector<std::string> path = ut::explode(std::string(argv[1]), '/');
  std::cout << path[path.size()-1].replace(path[path.size()-1].find(".tar.xz"), 7, "");
  return 0;
}
