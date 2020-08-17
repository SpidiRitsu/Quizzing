import os, pandas, sys
import mysql.connector


class ParseQuestions(object):

    def __init__(self, filepath):
        self.filepath = filepath
        self.cnx, self.cursor = self.initialize_mysql()
        self.data = []
        # self.id = sys.argv[1]
        self.quiz_id = 1

    @staticmethod
    def initialize_mysql():
        cnx = mysql.connector.connect(user='root', password='PASSWORD',
                                      host='HOSTNAME',
                                      database='DATABASE', port='3306')
        return cnx, cnx.cursor(buffered=True)

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
                {'QUESTION': row['QUESTION'], 'ANSWER_A': row['ANSWER_A'], 'ANSWER_B': row['ANSWER_B'],
                 'ANSWER_C': row['ANSWER_C'], 'ANSWER_D': row['ANSWER_D'],
                 'CORRECT': row['CORRECT']})
        rows_read = index + 1
        return rows_read

    def insert_to_db(self):
        for i in self.data:
            query = "insert into questions (question, answer_1, answer_2, answer_3, answer_4, correct_answer, quiz_id) VALUES ('{q}','{a}','{b}','{c}','{d}','{cor}',{id});".format(
                q=str(i['QUESTION']).replace("'", "''"),
                a=str(i['ANSWER_A']).replace("'", "''"),
                b=str(i['ANSWER_B']).replace("'", "''"),
                c=str(i['ANSWER_C']).replace("'", "''"),
                d=str(i['ANSWER_D']).replace("'", "''"),
                cor=str(i['CORRECT']).replace("'", "''"),
                id=self.quiz_id)
            query2 = 'commit;'
            self.cursor.execute(query)
            self.cursor.execute(query2)

    def run_all(self):
        """Runs all methods in correct order"""
        self.check_if_exists()
        self.recognize_extension()
        self.insert_to_db()
        self.cnx.close()


a = ParseQuestions(r'/mobile_apps/a.xlsx')
a.run_all()
