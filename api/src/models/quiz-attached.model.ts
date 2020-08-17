import {Entity, model, property, belongsTo} from '@loopback/repository';
import {Users} from './users.model';
import {QuizOwners} from './quiz-owners.model';

@model({
  settings: {
    foreignKeys: {
      'QuizAttached-UserId-FK': {
        name: 'QuizAttached-UserId-FK',
        foreignKey: 'userId',
        entityKey: 'id',
        entity: 'Users',
      },
      'QuizAttached-QuizId-FK': {
        name: 'QuizAttached-QuizId-FK',
        foreignKey: 'quizId',
        entityKey: 'id',
        entity: 'QuizOwners',
      },
    },
  },
})
export class QuizAttached extends Entity {
  @property({
    type: 'number',
    id: true,
    generated: true,
  })
  id?: number;

  @property({
    type: 'number',
  })
  progress?: number;

  @property({
    type: 'number',
  })
  score?: number;

  @property({
    type: 'date',
  })
  dateStarted?: string;

  @property({
    type: 'date',
  })
  dateFinished?: string;

  @belongsTo(() => Users, {}, {required: true})
  userId: number;

  @belongsTo(() => QuizOwners, {}, {required: true})
  quizId: number;

  constructor(data?: Partial<QuizAttached>) {
    super(data);
  }
}

export interface QuizAttachedRelations {
  // describe navigational properties here
}

export type QuizAttachedWithRelations = QuizAttached & QuizAttachedRelations;
