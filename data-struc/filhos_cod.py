import random
import logging
import threading
import time
import plotly.graph_objects as go


class MultiThread:

    def _init_(self):
        self.lista_media_hz = []
        self.cont = 1000000
        self.n = 1000
        self.cont_0 = self.cont
        self.parar = 0

    def do_media(self):
        acc = 0
        for i in range(self.n):
            acc += random.randint(0, 1000)
        w = round(acc / self.n)
        return w

    def thread_function(self):
        while self.parar == 0 and self.cont > 0:
            self.cont -= 1
            self.lista_media_hz[int(self.do_media())] += 1
        print("terminou")

    def test(self):
        for i in range(1000):
            self.lista_media_hz.append(0)

        t0 = time.time()
        panterior = 0
        lista = []
        tanterior = t0

        threads = []
        self.parar = 0

        while self.cont > 0:
            realizado = self.cont / self.cont_0
            porcentagem = round((1 - realizado) * 100, 2)

            t1 = time.time()

            if len(threads) >= 60 + 1:
                print("[1]")
                break

            x = threading.Thread(target=self.thread_function)
            threads.append(x)
            x.start()

            distancia = porcentagem - panterior
            tempo = t1 - tanterior
            velocidade = distancia / tempo
            lista.append(velocidade)

            panterior = porcentagem
            tanterior = t1

            print("velocidade de x consumers:" + "x =" + str(len(threads)))
            print(velocidade)
            print()
            print("---------------------------------------------------------------------------------")
            time.sleep(60)

        print("[2]")
        self.parar = 1
        for t in threads:
            print("[2.1]")
            # t.stop()
        print("[3] + " + str(len(lista)))
        fig = go.Figure([go.Bar(x= [i for i in range(60 + 1)], y = lista)])
        print("[4]")
        fig.show()
        print("[5]")

c = MultiThread()
c.test()
