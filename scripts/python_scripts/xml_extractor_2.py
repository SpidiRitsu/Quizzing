import os, pandas, sys
import mysql.connector
import requests
import json
import uuid


class ParseQuestions(object):

    def __init__(self):
        self.filepath = sys.argv[2]
        self.cnx, self.cursor = self.initialize_mysql()
        self.data = []
        self.user_name = sys.argv[1]
        print(self.filepath, self.user_name)
        self.main_site = 'https://latex2image.joeraut.com/convert'
        self.formula = None
        self.run_all()

    @staticmethod
    def initialize_mysql():
        cnx = mysql.connector.connect(user='root', password='zHHBZSvGNm4yzKt6',
                                      host='duckspace.tech',
                                      database='Quizzing', port='3307')
        return cnx, cnx.cursor(buffered=True)

    def create_new_quiz(self):
        # q1 = "select id from Users where username like '{usr_name}';".format(usr_name=self.user_name)
        # print('q1', q1)
        print(self.user_name)
        self.cursor.execute("select id from Users where username like '{usr_name}';".format(usr_name=self.user_name))

        quiz_owner = self.cursor.fetchall()[0][0]
        random_name = str(uuid.uuid4())
        quiz_name = 'IMPORTED_QUIZ_{quiz_time}'.format(quiz_time=random_name)
        acc_code = str(uuid.uuid4())
        # print(quiz_name) 2020-02-26
        self.cursor.execute(
            "insert into QuizOwners (quizName, quizOwner,accessCode,isActive,dateCreated) values ('{qz_name}', '{qz_owner}','{ac_code}',1,NOW());"
                .format(
                qz_owner=quiz_owner,
                qz_name=quiz_name,
                ac_code=acc_code, ))
        self.quiz_id = self.cursor.execute(
            "select id from QuizOwners where quizName like '{qz_name}';".format(qz_name=quiz_name))
        self.quiz_id = self.cursor.fetchall()[0][0]
        print(self.quiz_id)

    def check_if_exists(self):
        """Checks if file exists under given self.filepath variable"""
        file_status = os.path.exists(self.filepath)
        if file_status is False:
            raise Exception(FileNotFoundError)
        else:
            return True

    def recognize_extension(self):
        """Recognizes self.filepath file extensions and runs correct parse method"""
        filename, file_extension = os.path.splitext(self.filepath)
        if file_extension == '.xlsx' or file_extension == '.xls':
            self.parse_xlsx()
        elif file_extension == '.csv':
            self.parse_csv()
        else:
            raise Exception('UnknownFileFormat')

    def parse_xlsx(self):
        """
        Parses xlsx and xls file extensions for 1 question 4 answers and correct column in each row
        QUESTION;ANSWER_A;ANSWER_B;ANSWER_C;ANSWER_D;CORRECT must be the header in 1st row
        """
        data_tmp = pandas.read_excel(self.filepath)
        rows_read = self.parse_data(data_tmp)
        print('created: ' + str(rows_read) + ' Questions with answers')

    def parse_csv(self):
        """Parses csv file extension for 1 question 4 answers and correct column in each row
        QUESTION;ANSWER_A;ANSWER_B;ANSWER_C;ANSWER_D;CORRECT must be the header in 1st row"""
        # delim = sys.argv[2]
        delim = ';'
        data_tmp = pandas.read_csv(self.filepath, delimiter=delim)
        rows_read = self.parse_data(data_tmp)
        print('created: ' + str(rows_read) + ' Questions with answers')

    def parse_data(self, data):
        """Parses data from given dataframe"""
        for index, row in data.iterrows():
            self.data.append(
                {'QUESTION': row['QUESTION'], 'ANSWER_1': row['ANSWER_1'], 'ANSWER_2': row['ANSWER_2'],
                 'ANSWER_3': row['ANSWER_3'], 'ANSWER_4': row['ANSWER_4'],
                 'CORRECT': row['CORRECT']})
        rows_read = index + 1
        return rows_read

    def check_data_for_tex(self):
        """Changes values starting TEX= to TEX url image"""
        cnt = 0
        while cnt < len(self.data):
            for k, v in self.data[cnt].items():
                if type(v) == str:
                    if 'TEX=' in v:
                        formula = v[4:]
                        url = self.convert(formula)
                        self.data[cnt][k] = url
            cnt += 1

    def convert(self, formula):
        """Converts TEX to url"""
        # print(formula)
        r = requests.post(self.main_site, data={'latexInput': str(formula), 'outputFormat': 'PNG',
                                                'outputScale': '100%'})
        if r.status_code == 200:
            resp = json.loads(r.text)
            # print(resp)
            image_url = 'https://latex2image.joeraut.com/' + resp['imageURL']
            print(image_url)
            return image_url
        else:
            return False

    def insert_to_db(self):
        for i in self.data:
            query = "insert into Questions (question, answer1, answer2, answer3, answer4, correctAnswer, quizId) VALUES ('{q}','{a}','{b}','{c}','{d}','{cor}',{id});".format(
                q=str(i['QUESTION']).replace("'", "''"),
                a=str(i['ANSWER_1']).replace("'", "''"),
                b=str(i['ANSWER_2']).replace("'", "''"),
                c=str(i['ANSWER_3']).replace("'", "''"),
                d=str(i['ANSWER_4']).replace("'", "''"),
                cor=str(i['CORRECT']).replace("'", "''"),
                id=self.quiz_id)
            query2 = 'commit;'
            self.cursor.execute(query)
            self.cursor.execute(query2)

    def run_all(self):
        """Runs all methods in correct order"""
        self.check_if_exists()
        self.recognize_extension()
        self.check_data_for_tex()
        self.create_new_quiz()
        self.insert_to_db()
        self.cnx.close()


a = ParseQuestions()
# a.run_all()
