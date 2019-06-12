import json
from deepq_directory.state_preprocessor import StatePreprocessor


def learn(env):
    alpha = 0.7
    gamma = 1.0
    states_set = 0
    for i in range(1):
        print('-' * 150)
        print("Эпизод {}".format(i))
        try:
            fd = open('/Users/sergekulesh/PycharmProjects/Dota_bot эксперементы/openai_dir/strategy.json', 'r')
        except IOError:
            return
        strategy = json.load(fd)
        fd.close()

        state = env.reset()
        advise = int(state['advise'])
        state = StatePreprocessor.process(state)  # полученное состояние игры
        if str(state) not in strategy:  # добавили состояние
            strategy[str(state)] = {'1': 0, '0': 0}
            states_set += 1
        done = False
        total_reward = 0
        step = 0
        while not done:
            step += 1
            if strategy[str(state)] == {'1': 0, '0': 0}:
                    if advise == 0:
                        action = 0
                    else:
                        action = 1
            else:
                action = int(list(stat.keys())[list(stat.values()).index(max(stat.values()))])
            pairs = env.step(action)
            advise = int(pairs[0][1][0]['advise'])
            new_state = StatePreprocessor.process(pairs[0][1][0])
            if str(new_state) not in strategy:
                strategy[str(new_state)] = {'1': 0, '0': 0}  # добавили состояние
                states_set += 1
            reward = pairs[0][1][1]
            done = pairs[0][1][2]
            total_reward += reward
            old_value = strategy[str(state)][str(action)]
            stat = strategy[str(new_state)]
            next_max = max(list(stat.values()))
            new_value = (1 - alpha) * old_value + alpha * (int(reward) + gamma * next_max)
            strategy[str(state)].update({str(action): new_value})
            state = new_state

            fd = open('strategy.json', 'w')
            json.dump(strategy, fd)
            fd.close()

            print("-" * 100)

        print("К {} эпизоду награда составила {}, количество состояний игры  - {}".format(i, total_reward, states_set))
    return 1





