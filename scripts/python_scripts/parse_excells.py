import os
import imaplib

email = ''
password = ''

os.system(
    "attachment-downloader --host imap.gmail.com --username " + email + " --password " + password + " --imap-folder inbox --output ./downloaded_att")

box = imaplib.IMAP4_SSL('imap.gmail.com', 993)
box.login(email, password)
box.select('Inbox')
typ, data = box.search(None, 'ALL')
for num in data[0].split():
   box.store(num, '+FLAGS', '\\Deleted')
box.expunge()
box.close()
box.logout()

files_to_import = os.listdir('./downloaded_att')
for file in files_to_import:
    f_path = './downloaded_att/' + file
    filename, file_extension = os.path.splitext(f_path)
    f_name = ''
    for i in file:
        if i != '.':
            f_name += i
        else:
            break
    print('filename', f_name)
    print('fpath', f_path)
    os.system('python3 xml_extractor_2.py {user_name} {file_path}'.format(user_name=f_name, file_path=f_path))
    os.system('rm {path}'.format(path=f_path))
