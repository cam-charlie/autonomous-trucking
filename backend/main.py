from simulation.realm.realm import Realm
if __name__ == '__main__':
    r = Realm()
    print(r.containers)
    [print(f"id: {t.id}, dest: {t.destination}, route: {t.route}\n") for t in r.trucks.values()]