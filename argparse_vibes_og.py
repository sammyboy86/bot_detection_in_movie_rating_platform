#! /home/sammyboy86/Documents/fdd_python_env/bin/python3.10

from argparse import ArgumentParser


if __name__ == '__main__':
   # Instantiate arg_parser
   args = ArgumentParser()
   # Add argument
   args.add_argument('-s', '--user_string', help='A string provided by the user. ', type=str)
   args.add_argument('-a', '--user_age', help='The age of the user.', type=int)
   # Instantiate parser
   pars = args.parse_args()
   # Get args
   user_string = pars.user_string
   age = pars.user_age
   # Print results
   print('User string:\n', user_string)
   print('User age: \n', age)
