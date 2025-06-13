from PIL import Image
import numpy as np
import os

def bin_str_to_hex(bin_str):
    """将二进制字符串转换为十六进制字符串"""
    padding = (4 - len(bin_str) % 4) % 4
    bin_str = bin_str.zfill(len(bin_str) + padding)
    hex_str = ''.join(f"{int(bin_str[i:i+4], 2):x}" for i in range(0, len(bin_str), 4))
    return hex_str

print("开始处理图像...")

# 输出文件
output_file = "all_images.v"

with open(output_file, "w", encoding="utf-8") as f_out:

    for i in range(60):
        angle = i * 6
        filename = f"rotated_{angle:03d}.bmp"

        if not os.path.exists(filename):
            print(f"文件 {filename} 不存在！")
            continue

        # 打开图像并转为灰度图
        img = Image.open(filename).convert('L')
        img = img.resize((80, 80))  # 修改为 80x80

        # 转为黑白二值图像：黑色为1，白色为0
        data = np.array(img)
        binary_data = (data < 128).astype(int)

        # 构建Verilog数组行
        verilog_items = []
        for row in binary_data:
            bin_str = ''.join(str(bit) for bit in row)
            hex_str = bin_str_to_hex(bin_str)
            verilog_items.append(f"80'h{hex_str}")  # 修改为 80'h...

        # 每四组拼成一行
        lines = []
        for i in range(0, len(verilog_items), 4):
            chunk = verilog_items[i:i+4]
            line = ", ".join(chunk)
            if i + 4 < len(verilog_items):
                line += ","
            lines.append(line)

        array_body = "\n    ".join(lines)

        # 变量名
        var_name = f"second_{angle:03d}"

        # 写入文件
        f_out.write(f"wire [0:79] {var_name} [0:79] = '{{\n")  # 修改为 0:79
        f_out.write(f"    {array_body}\n")
        f_out.write("};\n\n")

    print(f"已合并保存到 {output_file}")