COUNTER = 0
_taken = {}

def registerID(id: int) -> None:
    _taken[id] = True

def generateID() -> int:
    global COUNTER
    while _taken.get(COUNTER,False):
        COUNTER += 1
    registerID(COUNTER)
    return COUNTER


