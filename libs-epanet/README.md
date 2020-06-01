# Tutorial instalação Wrapper e EPANET - OpenWatterAnalytics

## Baixar arquivos e compilar
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

## Chamando o wrapper no código

Depois de baixar e escolher uma pasta fixa para deixar esses arquivos, você poderá escolher dois meios de chamar o wrapper.

### sys.path
Você pode adicionar o caminho do `epamodule.py` ao sys.path da seguinte maneira:

~~~ python
import sys
sys.path.append('/caminho/do/modulo/epanet-python/epanet-module/')
~~~

Depois disso, basta chamar o módulo assim:

~~~ python
import epamodule
~~~

Observe que utilizando a importação desta maneira, você terá de adicionar esse caminho no inicio de todo código que for utilizar o módulo.

### Link simbólico
Outra opção é criar um link simbólico em algum diretório já listado no `sys.path`. Assim, você poderá chamar o módulo sem ter que adicionar ao `sys.path`.

~~~ shell
# Terminal
ln -s /caminho/do/arquivo/epanet-python/epanet-module/epamodule ~/.local/lib/pythonX.Y/site-packages/epamodule
~~~

~~~ python
import epamodule
~~~
