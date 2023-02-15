COUNTER = 0

def generateID() -> int:
    global COUNTER
    COUNTER += 1
    return COUNTER
    