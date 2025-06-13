from PIL import Image
import os

def rotate_image(input_path, output_folder):
    # 创建输出文件夹
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)
    
    # 打开原始图像
    original_img = Image.open(input_path)
    
    # 旋转60次，每次6度
    for i in range(12):
        # 计算当前旋转角度
        angle =  30 * i
        
        # 旋转图像，使用Image.BICUBIC插值以获得更好的质量
        # 设置expand=False以保持原始尺寸
        rotated_img = original_img.rotate(-angle, resample=Image.BICUBIC, expand=False,
                                          fillcolor=(255,255,255))
        
        # 保存旋转后的图像
        output_path = os.path.join(output_folder, f"rotated_{angle:03d}.bmp")
        rotated_img.save(output_path)
        
        print(f"已生成: {output_path}")

# 使用示例
input_image = "hour.bmp"  # 替换为你的240x240图片路径
output_directory = "hour_rotated_images"

rotate_image(input_image, output_directory)
print("所有旋转图像已生成完毕！")