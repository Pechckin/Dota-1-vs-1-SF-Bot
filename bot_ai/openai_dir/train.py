import sys
import multiprocessing


import numpy as np

from baselines.common import models
from baselines.common.cmd_util import common_arg_parser, parse_unknown_args
from openai_dir.deepq_openai.deepq import learn


from dotaenv.environment import DotaEnvironment


def train(args, extra_args):
    env_type = 'steam'
    env_id = 'dota2'
    print('env_type: {}'.format(env_type))

    alg_kwargs = dict(
        network=models.mlp(num_hidden=128, num_layers=1),
        lr=1e-3,
        buffer_size=10000,
        total_timesteps=500000,
        propertyexploration_fraction=1.0,
        exploration_initial_eps=0.1,
        exploration_final_eps=0.1,
        train_freq=4,
        target_network_update_freq=1000,
        gamma=0.999,
        batch_size=32,
        prioritized_replay=True,
        prioritized_replay_alpha=0.6,
        experiment_name='test',
        dueling=True
    )
    alg_kwargs.update(extra_args)
    env = DotaEnvironment()
    print('Training {} on {}:{} with arguments \n{}'.format(args.alg, env_type, env_id, alg_kwargs))

    pool_size = multiprocessing.cpu_count()
    with multiprocessing.Pool(processes=pool_size) as pool:
        model = learn(env=env)

    return model, env


def parse_cmdline_kwargs(args):
    '''
    convert a list of '='-spaced command-line arguments to a dictionary, evaluating python objects when possible
    '''
    def parse(v):
        assert isinstance(v, str)
        try:
            return eval(v)
        except (NameError, SyntaxError):
            return v
 
    return {k: parse(v) for k,v in parse_unknown_args(args).items()}


def main(args):

    np.set_printoptions(precision=3) # по дефолту 8 знаков после запятой , теперь 3

    arg_parser = common_arg_parser()


    args, unknown_args = arg_parser.parse_known_args(args)
    extra_args = parse_cmdline_kwargs(unknown_args)

    model, env = train(args, extra_args)
    return model


if __name__ == '__main__':
    main(sys.argv)

