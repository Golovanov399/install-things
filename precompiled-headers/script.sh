#!/bin/bash

mkdir -p Debug/bits
g++ -DLOCAL -std=c++17 -g -O0 -D_GLIBCXX_DEBUG -Wall -Wextra -x c++-header /usr/include/x86_64-linux-gnu/c++/7/bits/stdc++.h -o Debug/bits/stdc++.h.gch
cp /usr/include/x86_64-linux-gnu/c++/7/bits/stdc++.h Debug/bits/
echo "Debug generated"
mkdir -p Release/bits
g++ -DLOCAL -std=c++17 -O2 -Wno-unused-result -x c++-header /usr/include/x86_64-linux-gnu/c++/7/bits/stdc++.h -o Release/bits/stdc++.h.gch
cp /usr/include/x86_64-linux-gnu/c++/7/bits/stdc++.h Release/bits/
echo "Release generated"
