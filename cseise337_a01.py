from collections import Counter


# Problem 1 – Chaotic Strings
def is_chaotic(s):
    counts = Counter(s).values()
    return 'TOHRU' if len(counts) == len(set(counts)) else 'ELMA'


# print("aabbcd is " + is_chaotic("aabbcd"))
# print("aaaabbbccd is " + is_chaotic("aaaabbbccd"))
# print("abaacccdee is " + is_chaotic("abaacccdee"))

# Problem 2 – Balanced Brackets


def is_balanced(s):
    stack = []
    for c in s:
        if c == '(' or c == '[' or c == '{':
            stack.append(c)
        else:
            if not stack:
                return False
            if c == ')' and stack[-1] != '(':
                return False
            if c == ']' and stack[-1] != '[':
                return False
            if c == '}' and stack[-1] != '{':
                return False
            stack.pop()
    if len(stack) == 0:
        return True


# print(is_balanced("{[()]}"))
# print(is_balanced("{[(])}"))
# print(is_balanced("{{[[(())]]}}"))

# Problem 3 – Functional Programming


def even(x):
    return x % 2 == 0


def odd(x):
    return x % 2 == 1


def winning_function(a, even, odd):
    count_even = 0
    count_odd = 0
    for i in a:
        if even(i):
            count_even += 1
        if odd(i):
            count_odd += 1
    if count_even > count_odd:
        return "EVEN"
    elif count_even < count_odd:
        return "ODD"
    else:
        return "TIE"


# print(winning_function([2, 3, 4, 5, 6, 8], even, odd))


# Problem 4 – Representing Filesystems

class FS_Item:
    def __init__(self, name):
        self.name = name


class Folder(FS_Item):
    def __init__(self, name):
        super().__init__(name)
        self.items = []

    def add_item(self, item):
        self.items.append(item)


class File(FS_Item):
    def __init__(self, name, size):
        super().__init__(name)
        self.size = size


def load_fs(ls_output):
    folder_directory = {}
    current_folder = None
    folder_directory["."] = Folder(".")  # add root folder to the dictionary at initialization
    with open(ls_output, 'r') as file:
        for line in file:
            line = line.strip()  # open file, read line by line and strip whitespace
            if line.startswith("."):  # if path
                current_dir = line[:-1]  # remove the colon, name this path current_dir
                if current_dir not in folder_directory:
                    if current_dir == ".":  # if root, skip
                        continue
                    else:  # otherwise, take the name as the last item in the path. Colon is ALREADY REMOVED.
                        folder_name = current_dir.split("/")[-1]
                        new_folder = Folder(folder_name)
                        folder_directory[current_dir] = new_folder

                if current_dir != ".":
                    parent_dir = "/".join(current_dir.split("/")[:-1])  # get the parent directory
                else:
                    current_folder = folder_directory["."]
                    continue  # if root, skip

                if parent_dir in folder_directory:
                    folder_directory[parent_dir].add_item(new_folder)

                current_folder = new_folder

            elif line.startswith("total"):
                continue
            elif line == "":
                continue

            else:  # if file
                tokens = line.split()  # split line into parts, "tokens"
                perms = tokens[0]  # get permissions
                size = int(tokens[4])
                file_name = tokens[8]

                if perms[0] == "d":  # if directory
                    continue

                else:  # if file
                    new_file = File(file_name, int(size))
                    current_folder.add_item(new_file)

    return folder_directory["."]


# Problem 5 – Decoding


def decode(ct):
    alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u",
                "v", "w", "x", "y", "z"]
    decoded = ""  # output string
    prev_char = 0  # sum of all previous characters' ordinal values
    for i in range(len(ct)):
        if i == 0:  # if first character
            prev_char = ord(ct[i])
            first_char = (ord(ct[i]) + 59) % 26
            decoded += alphabet[first_char]
            continue
        if ct[i] not in "abcdefghijklmnopqrstuvwxyz":  # if special character
            decoded += ct[i]
            continue
        else:  # if cyphertext letters
            char = (ord(ct[i]) + prev_char) % 26  # decoded character = ordinal of cyphertext + prev_char, modulo 26
            decoded += alphabet[char]
            prev_char += ord(ct[i])

    return decoded
