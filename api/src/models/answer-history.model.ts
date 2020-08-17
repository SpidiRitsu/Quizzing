import {Entity, model, property, belongsTo} from '@loopback/repository';
import {QuizAttached} from './quiz-attached.model';
import {Questions} from './questions.model';
import {Users} from './users.model';

@model({
  settings: {
    foreignKeys: {
      'AnswerHistory-StartedQuizId-FK': {
        name: 'AnswerHistory-StartedQuizId-FK',
        foreignKey: 'startedQuizId',
        entityKey: 'id',
        entity: 'QuizAttached',
      },
      'AnswerHistory-QuestionId-FK': {
        name: 'AnswerHistory-QuestionId-FK',
        foreignKey: 'questionId',
        entityKey: 'id',
        entity: 'Questions',
      },
      'AnswerHistory-UserId-FK': {
        name: 'AnswerHistory-UserId-FK',
        foreignKey: 'userId',
        entityKey: 'id',
        entity: 'Users',
      },
    },
  },
})
export class AnswerHistory extends Entity {
  @property({
    type: 'number',
    id: true,
    generated: true,
  })
  id?: number;

  @property({
    type: 'string',
    required: true,
  })
  answer: string;

  @belongsTo(() => QuizAttached, {name: 'quiz'}, {required: true})
  startedQuizId: number;

  @belongsTo(() => Questions, {}, {required: true})
  questionId: number;

  @belongsTo(() => Users, {}, {required: true})
  userId: number;

  constructor(data?: Partial<AnswerHistory>) {
    super(data);
  }
}

export interface AnswerHistoryRelations {
  // describe navigational properties here
}

export type AnswerHistoryWithRelations = AnswerHistory & AnswerHistoryRelations;
