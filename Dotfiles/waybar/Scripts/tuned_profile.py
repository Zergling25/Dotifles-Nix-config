import subprocess
import json

def tuned_profile_name():
    result = subprocess.run(['tuned-adm', 'active'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    profile = result.stdout.decode('utf-8').strip()

    if "powersave" in profile:
        output = "  PotatoMode"
    elif "balance" in profile:
        output = "  BalancedMode"
    else:
        output = "  What profile are you even using?"

    # Wrap the output in a dictionary for proper JSON formatting
    print(json.dumps({"text": output}), flush=True)

# Call the function
tuned_profile_name()

