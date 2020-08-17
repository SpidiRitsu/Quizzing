import { Entity, model, property, belongsTo } from '@loopback/repository';
import { Users } from './users.model';
import { QuizOwners } from './quiz-owners.model';

@model({
  settings: {
    strict: false,
    foreignKeys: {
      'QuizToUser-QuizId-FK': {
        name: 'QuizToUser-QuizId-FK',
        foreignKey: 'quizId',
        entityKey: 'id',
        entity: 'QuizOwners',
      },
      'QuizToUser-UserId-FK': {
        name: 'QuizToUser-UserId-FK',
        foreignKey: 'userId',
        entityKey: 'id',
        entity: 'Users',
      },
    },
  },
})
export class QuizToUser extends Entity {
  @property({
    type: 'date',
    required: true,
  })
  dateAttached: string;

  @belongsTo(() => QuizOwners, {}, { id: 1, required: true })
  quizId: number;

  @belongsTo(() => Users, {}, { id: 2, required: true })
  userId: number;

  [prop: string]: any;
  constructor(data?: Partial<QuizToUser>) {
    super(data);
  }
}

export interface QuizToUserRelations {
  // describe navigational properties here
}

export type QuizToUserWithRelations = QuizToUser & QuizToUserRelations;
