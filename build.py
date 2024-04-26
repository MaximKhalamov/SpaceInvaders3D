import os
import re
import shutil


SRC_DIRECTORY = "./src"
DEST_JAVA_DIRECTORY = "./buildJava/SpaceInvaders"
DEST_ANDROID_DIRECTORY = "./buildAndroid/SpaceInvaders"
PROCESSING_JAVA_PATH = "/home/max/Desktop/processing-4.3/processing-java"


def main():
    copy_dir(SRC_DIRECTORY + "/androidClasses", DEST_ANDROID_DIRECTORY)
    copy_dir(SRC_DIRECTORY + "/javaClasses", DEST_JAVA_DIRECTORY)
    copy_dir("./assets", DEST_ANDROID_DIRECTORY + "/data")
    copy_dir("./assets", DEST_JAVA_DIRECTORY + "/assets")

    copy_dir("./data", DEST_ANDROID_DIRECTORY + "/data")
    copy_dir("./data", DEST_JAVA_DIRECTORY + "/data")
    preprocess()

    # --variant is broken?
    os.system(f"{PROCESSING_JAVA_PATH} --sketch={DEST_JAVA_DIRECTORY} --variant=windows-amd64 --export")
    shutil.rmtree(DEST_JAVA_DIRECTORY + "/windows-amd64/source")
    shutil.copy(SRC_DIRECTORY + "/javaClasses/config.properties", DEST_JAVA_DIRECTORY + "/windows-amd64/config.properties")
    copy_dir("./assets", DEST_JAVA_DIRECTORY + "/windows-amd64/assets")

    if os.path.isdir('./windows-amd64/'):
        shutil.rmtree("./windows-amd64/")
    shutil.move(DEST_JAVA_DIRECTORY + "/windows-amd64", "./")


def get_text_condition(*words):
    for word in words:
        yield word, "if(" + word + "){"


def replace_ifs(text, condition):
    for plat, cond_text in get_text_condition("ANDROID", "JAVA"):
        while text.find(cond_text) != -1:
            stack = 1
            # lines = text[text.find(cond_text) + len(cond_text):].split("\n")
            code = ""
            for i in text[text.find(cond_text) + len(cond_text):]:
                if i == "{":
                    stack += 1
                elif i == "}":
                    stack -= 1
                    if stack == 0:
                        break
                code += i                
            # print(code)
            if condition != plat:
                text = text[:text.find(cond_text)] + text[text.find(cond_text) + len(cond_text) + len(code) + 2:]
            else:
                text = text[:text.find(cond_text)] + code + text[text.find(cond_text) + len(cond_text) + len(code) + 2:]

    return text

def replace_pattern(text):
    ''' Return code for Android and java as 1st and 2nd argument '''
    return replace_ifs(text, "ANDROID"), replace_ifs(text, "JAVA")


def preprocess():
    files = os.listdir("./src")
    for file_name in files:
        if os.path.isfile(os.path.join(SRC_DIRECTORY, file_name)):
            with open(os.path.join(SRC_DIRECTORY, file_name), 'r') as file:
                print(f"Processing file: {file_name}")
                content = file.read()
                pattern = r"IF\(ANDROD\)\s*(.*?)\s*ELSE\s*(.*?)\s*END"
                matches = re.findall(pattern, content, flags=re.DOTALL)
                matches = re.findall(pattern, content)

                result_android, result_java = replace_pattern(content)

            with open(os.path.join(DEST_JAVA_DIRECTORY, file_name), 'w') as destination:
                destination.write(result_java)

            with open(os.path.join(DEST_ANDROID_DIRECTORY, file_name), 'w') as destination:
                destination.write(result_android)

    pass


def copy_dir(src_dir, dest_dir):
    try:
        if not os.path.exists(dest_dir):
            os.makedirs(dest_dir)
        
        for item in os.listdir(src_dir):
            src_item = os.path.join(src_dir, item)
            dest_item = os.path.join(dest_dir, item)
            if os.path.isdir(src_item):
                copy_dir(src_item, dest_item)
            else:
                shutil.copy2(src_item, dest_item)

    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    main()