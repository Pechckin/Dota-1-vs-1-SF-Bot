class StatePreprocessor:

    @staticmethod
    def process(state):
        cX = state['creeps_X']
        cY = state['creeps_Y']
        cH = state['hero']
        state = ""
        for i in cH:
            state += str(abs(i))
        for i in cX:
            state += str(abs(i))
        for i in cY:
            state += str(abs(i))
        return state

