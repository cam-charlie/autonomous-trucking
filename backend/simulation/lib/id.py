COUNTER = 0
_taken = {}

def registerID(id_: int) -> None:
    _taken[id_] = True

def generateID() -> int:
    #pylint: disable=global-statement
    global COUNTER
    while _taken.get(COUNTER,False):
        COUNTER += 1
    registerID(COUNTER)
    return COUNTER
