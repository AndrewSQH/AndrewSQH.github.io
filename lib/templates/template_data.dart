import '../models/template.dart';

class TemplateData {
  static List<Template> getTemplates() {
    return [
      // 竖向明信片模板
      // 明信片风格模板 1: 顶部图片 + 底部文字
      Template(
        id: 'pattern_1',
        name: '清风笺',
        borderColor: '#FFFFFF',
        backgroundColor: '#FFFFFF',
        borderWidth: 1.0,
        borderRadius: 8.0,
        filterName: 'hefe',
        imagePath: 'assets/templates/1.jpg',
      ),
      // 明信片风格模板 2: 顶部文字 + 底部图片
      Template(
        id: 'pattern_2',
        name: '明月笺',
        borderColor: '#FFFFFF',
        backgroundColor: '#FFFFFF',
        borderWidth: 1.0,
        borderRadius: 8.0,
        filterName: 'inkwell',
        imagePath: 'assets/templates/pexels-1108936515-20895480.jpg',
      ),
      // 明信片风格模板 3: 顶部图片 + 底部居中文字
      Template(
        id: 'pattern_3',
        name: '岁月笺',
        borderColor: '#FFFFFF',
        backgroundColor: '#FFFFFF',
        borderWidth: 1.0,
        borderRadius: 8.0,
        filterName: 'lomo',
        imagePath: 'assets/templates/pexels-bertellifotografia-573299.jpg',
      ),
      // 明信片风格模板 4: 顶部图片 + 底部居中文字
      Template(
        id: 'pattern_4',
        name: '云舒笺',
        borderColor: '#FFFFFF',
        backgroundColor: '#FFFFFF',
        borderWidth: 1.0,
        borderRadius: 8.0,
        filterName: 'valencia',
        imagePath: 'assets/templates/pexels-cheng-shi-song-427082720-34903203.jpg',
      ),
      // 明信片风格模板 5: 顶部文字 + 底部图片
      Template(
        id: 'pattern_5',
        name: '花开笺',
        borderColor: '#FFFFFF',
        backgroundColor: '#FFFFFF',
        borderWidth: 1.0,
        borderRadius: 8.0,
        filterName: 'nashville',
        imagePath: 'assets/templates/pexels-dmitri-sotnikov-2712820-32219500.jpg',
      ),
      // 明信片风格模板 6: 左侧文字 + 右侧图片
      Template(
        id: 'pattern_6',
        name: '流年笺',
        borderColor: '#FFFFFF',
        backgroundColor: '#FFFFFF',
        borderWidth: 1.0,
        borderRadius: 8.0,
        filterName: 'sutro',
        imagePath: 'assets/templates/pexels-elizabeth-ferreira-1040803688-29649276.jpg',
      ),
      // 明信片风格模板 7: 顶部图片 + 底部文字
      Template(
        id: 'pattern_7',
        name: '安然笺',
        borderColor: '#FFFFFF',
        backgroundColor: '#FFFFFF',
        borderWidth: 1.0,
        borderRadius: 8.0,
        filterName: 'rise',
        imagePath: 'assets/templates/pexels-jess-vide-4321835.jpg',
      ),
      
      // 新增竖向模板
      Template(
        id: 'pattern_8',
        name: '田园笺',
        borderColor: '#FFFFFF',
        backgroundColor: '#FFFFFF',
        borderWidth: 1.0,
        borderRadius: 8.0,
        filterName: 'inkwell',
        imagePath: 'assets/templates/pexels-carocastilla-1716861.jpg',
      ),
      Template(
        id: 'pattern_9',
        name: '云海笺',
        borderColor: '#FFFFFF',
        backgroundColor: '#FFFFFF',
        borderWidth: 1.0,
        borderRadius: 8.0,
        filterName: 'lomo',
        imagePath: 'assets/templates/pexels-h-i-nguy-n-1627264-3616937.jpg',
      ),
      Template(
        id: 'pattern_10',
        name: '古城笺',
        borderColor: '#FFFFFF',
        backgroundColor: '#FFFFFF',
        borderWidth: 1.0,
        borderRadius: 8.0,
        filterName: 'valencia',
        imagePath: 'assets/templates/pexels-soldiervip-1382730.jpg',
      ),
      Template(
        id: 'pattern_11',
        name: '晨雾笺',
        borderColor: '#FFFFFF',
        backgroundColor: '#FFFFFF',
        borderWidth: 1.0,
        borderRadius: 8.0,
        filterName: 'nashville',
        imagePath: 'assets/templates/pexels-tomer-dahari-571687-1331386.jpg',
      ),
      
      // 横向明信片模板
      // 横向明信片模板 1
      Template(
        id: 'pattern_horizontal_1',
        name: '横向经典',
        borderColor: '#FFFFFF',
        backgroundColor: '#FFFFFF',
        borderWidth: 1.0,
        borderRadius: 8.0,
        filterName: 'hefe',
        imagePath: 'assets/templates/pexels-lis-k-1975161963-30884074.jpg',
      ),
      // 横向明信片模板 2
      Template(
        id: 'pattern_horizontal_2',
        name: '横向风景',
        borderColor: '#FFFFFF',
        backgroundColor: '#FFFFFF',
        borderWidth: 1.0,
        borderRadius: 8.0,
        filterName: 'inkwell',
        imagePath: 'assets/templates/pexels-ozge-taskiran-85164141-12596936.jpg',
      ),
      // 横向明信片模板 3
      Template(
        id: 'pattern_horizontal_3',
        name: '横向简约',
        borderColor: '#FFFFFF',
        backgroundColor: '#FFFFFF',
        borderWidth: 1.0,
        borderRadius: 8.0,
        filterName: 'lomo',
        imagePath: 'assets/templates/pexels-paul-robinson-1446229-2796781.jpg',
      ),
      // 横向明信片模板 4
      Template(
        id: 'pattern_horizontal_4',
        name: '横向文艺',
        borderColor: '#FFFFFF',
        backgroundColor: '#FFFFFF',
        borderWidth: 1.0,
        borderRadius: 8.0,
        filterName: 'valencia',
        imagePath: 'assets/templates/pexels-sam-lim-655865-1586206.jpg',
      ),
      // 横向明信片模板 5
      Template(
        id: 'pattern_horizontal_5',
        name: '横向现代',
        borderColor: '#FFFFFF',
        backgroundColor: '#FFFFFF',
        borderWidth: 1.0,
        borderRadius: 8.0,
        filterName: 'nashville',
        imagePath: 'assets/templates/pexels-thai-hu-nh-2335830-3998365.jpg',
      ),
      // 横向明信片模板 6
      Template(
        id: 'pattern_horizontal_6',
        name: '横向自然',
        borderColor: '#FFFFFF',
        backgroundColor: '#FFFFFF',
        borderWidth: 1.0,
        borderRadius: 8.0,
        filterName: 'sutro',
        imagePath: 'assets/templates/pexels-the-traveling-photo-experiment-41034029-8399147.jpg',
      ),
      // 横向明信片模板 7
      Template(
        id: 'pattern_horizontal_7',
        name: '横向城市',
        borderColor: '#FFFFFF',
        backgroundColor: '#FFFFFF',
        borderWidth: 1.0,
        borderRadius: 8.0,
        filterName: 'rise',
        imagePath: 'assets/templates/pexels-thek1d-773594.jpg',
      ),
      // 横向明信片模板 8
      Template(
        id: 'pattern_horizontal_8',
        name: '横向人物',
        borderColor: '#FFFFFF',
        backgroundColor: '#FFFFFF',
        borderWidth: 1.0,
        borderRadius: 8.0,
        filterName: 'toaster2',
        imagePath: 'assets/templates/pexels-valeriya-19287463.jpg',
      ),
      // 横向明信片模板 9
      Template(
        id: 'pattern_horizontal_9',
        name: '横向建筑',
        borderColor: '#FFFFFF',
        backgroundColor: '#FFFFFF',
        borderWidth: 1.0,
        borderRadius: 8.0,
        filterName: 'hefe',
        imagePath: 'assets/templates/pexels-zhangkaiyv-16144420.jpg',
      ),
      // 横向明信片模板 10
      Template(
        id: 'pattern_horizontal_10',
        name: '横向花卉',
        borderColor: '#FFFFFF',
        backgroundColor: '#FFFFFF',
        borderWidth: 1.0,
        borderRadius: 8.0,
        filterName: 'inkwell',
        imagePath: 'assets/templates/pexels-zhangkaiyv-3210189.jpg',
      ),
    ];
  }
}


