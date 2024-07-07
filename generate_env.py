with open(".env") as fin, open("lib/env_options.dart", "w+") as fout:
    lines = fin.readlines()
    values = []

    for line in lines:
        line = line.replace("\n", "")
        if len(line.strip()) > 0:
            values.append(f"  static const String {line};")
    combined = "\n".join(values)
    template = '''sealed class EnvOptions {{
{combined}
}}'''.format(combined=combined)
    fout.write(template)
