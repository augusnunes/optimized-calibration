# Gradient descent

## Códigos envolvidos
- **../epamodule/epamodule.jl**: Wrapper da biblioteca do EPANET
- **../epanet/epanet.jl**: Módulo de manipulação da simulação e da rede
- **./derivative.jl**: Módulo das derivadas
- **./gradient.jl**: Onde é chamado o restante dos módulos e é executado todo o código

## Arquivos de saída (./tests/)
Os arquivos seguem o formato .csv. Desconsidere as colunas "i" e "rn".

## Função objetivo
A função objetivo do problema se chama **simula** e se encontra no arquivo **../epanet/epanet.jl**.

