import {Entity, model, property, belongsTo} from '@loopback/repository';
import {QuizOwners} from './quiz-owners.model';

@model({
  settings: {
    foreignKeys: {
      'Questions-QuizId-FK': {
        name: 'Questions-QuizId-FK',
        foreignKey: 'quizId',
        entityKey: 'id',
        entity: 'QuizOwners',
      },
    },
  },
})
export class Questions extends Entity {
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
  question: string;

  @property({
    type: 'string',
  })
  answer1?: string;

  @property({
    type: 'string',
  })
  answer2?: string;

  @property({
    type: 'string',
  })
  answer3?: string;

  @property({
    type: 'string',
  })
  answer4?: string;

  @property({
    type: 'string',
    required: true,
  })
  correctAnswer: string;

  @belongsTo(() => QuizOwners, {}, {required: true})
  quizId: number;

  constructor(data?: Partial<Questions>) {
    super(data);
  }
}

export interface QuestionsRelations {
  // describe navigational properties here
}

export type QuestionsWithRelations = Questions & QuestionsRelations;
