
import os

commandFile = "Shell/Command.sh"

exit_code= os.system(commandFile)


if exit_code == 0:
    print("Script executed successfully.")
else:
    print("Script failed with exit code:", exit_code)