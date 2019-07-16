import argparse
import random

def main():
    parser = argparse.ArgumentParser('Notes generator')
    parser.add_argument('--low', type=int, default=84, help='Lowest note')
    parser.add_argument('--high', type=int, default=95, help='Highest note')
    parser.add_argument('-n', '--num', type=int, default=20000, help='Number of notes to generate')
    args = parser.parse_args()

    notes = [note for note in range(args.low, args.high + 1)]

    with open('example.txt', 'w', encoding='utf-8') as fp:
        curr = random.choice(notes)
        for i in range(args.num):
            fp.write(str(curr) + '\n')
            rand_num = random.random()
            if rand_num < 0.3:
                curr = curr + 1
                if curr > args.high:
                    curr = args.low
            elif rand_num < 0.6:
                curr = curr - 1
                if curr < args.low:
                    curr = args.high
            elif rand_num < 0.9:
                curr = random.choice(notes)

if __name__ == "__main__":
    main()