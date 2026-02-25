 #!/bin/bash
 # fix_cocoapods_scripts.sh

 echo "修复 CocoaPods 脚本权限..."

 # 1. 修复所有脚本文件
 find Pods -name "*.sh" -o -name "*.rb" | while read script; do
     chmod +x "$script"
     # 移除隔离属性
     sudo xattr -rd com.apple.quarantine "$script" 2>/dev/null || true
 done

 # 2. 修复目标支持文件
 find "Pods/Target Support Files" -type f | while read file; do
     chmod 644 "$file"
     chown $(whoami) "$file"
 done

 # 3. 修复 resources-to-copy 文件
 find Pods -name "resources-to-copy-*.txt" -type f | while read file; do
     rm -f "$file"
 done

 # 4. 重新生成
 pod install --no-repo-update

 echo "✅ 脚本权限修复完成"
