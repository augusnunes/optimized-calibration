# Tutorial instalação Wrapper e EPANET - OpenWatterAnalytics

Baixe os arquivos da biblioteca do EPANET em C/C++ [nesse link](https://github.com/OpenWaterAnalytics/EPANET/). Navegue até os arquivos e faz um build com Cmake.

```
git clone https://github.com/OpenWaterAnalytics/EPANET/
cd EPANET/
mkdir build/
cd build
cmake ..
cmake --build . config Release
```

O arquivo da biblioteca estará em `./include/epanet2_2.h`. Se quiser você pode testar ela utilizando esse código a seguir.
~~~ c++
// teste.cpp
#include "epanet2_2.h"
~~~

Tente compilar o arquivo usando `gcc teste.cpp -o exec`. Se compilar, então quer dizer que está funcionando para a linguagem C/C++.

Verifique se o arquivo `./build/lib/libepanet2.so` foi gerado. 

Depois disso, baixe os arquivos do wrapper de python disponibilizado pela OWA [neste link](https://github.com/OpenWaterAnalytics/epanet-python). Você terá que modificar o arquivo `./epanet-python/epanet-module/epamodule.py`

```
git clone https://github.com/OpenWaterAnalytics/epanet-python
cd epanet-python/epanet-module/
nano epamodule.py
```

Na linha onde está o seguinte código, substitua pelo caminho completo do arquivo `libepanet2.so`. É importante que você deixe os arquivos do EPANET sempre em um lugar, para que eventualmente não dê errado quando o wrapper for chamado.

~~~ python
# Original
if _plat=='Linux':
  _lib = ctypes.CDLL("libepanet2.so.2")
~~~

~~~ python
# Solução
if _plat=='Linux':
  _lib = ctypes.CDLL("/home/$user/EPANET/build/lib/libepanet2.so")
~~~

Depois disso, você poderá chamar o wrapper com:

~~~ python
import epamodule
~~~

Observe que você terá que estar na mesma pasta que este arquivo. O arquivo se localiza em `epanet-python/epanet-module/epamodule.py`. Você pode executar seu código em qualquer diretório, desde que adicione o caminho dele em `sys.path` no inicio do código.

~~~ python
import sys
sys.path.append('/home/$user/.../epanet-python/epanet-module/')
~~~

Deve haver outras maneiras de evitar essa chamada, e tornar as coisas mais simples. Exemplo a seguir:

~~~ python
import sys
sys.path.append('/home/augusto/Documents/epanet-python/epanet-module/')

import epamodule as em
em.ENopen("/home/augusto/Documents/epanet_arquivos/teste21.inp")
~~~

