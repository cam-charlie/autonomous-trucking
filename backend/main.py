from simulation.realm.realm import Realm
from simulation.realm.graph import Road

if __name__ == '__main__':
    r = Realm()
    print(r.containers)
    [print(f"id: {t.id}, dest: {t.destination}, route: {t.route}") for t in r.trucks.values()]