from simulation.realm.realm import Realm
from simulation.realm.graph import Road
from simulation.draw.visualiser import Visualiser

if __name__ == '__main__':
    r = Realm()
    v = Visualiser(r)
    v.start()