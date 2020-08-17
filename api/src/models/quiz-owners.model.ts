import {Entity, model, property, belongsTo} from '@loopback/repository';
import {Users} from './users.model';

@model({
  settings: {
    foreignKeys: {
      'QuizOwners-QuizOwner-FK': {
        name: 'QuizOwners-QuizOwner-FK',
        foreignKey: 'quizOwner',
        entityKey: 'id',
        entity: 'Users',
      },
    },
  },
})
export class QuizOwners extends Entity {
  @property({
    type: 'number',
    id: true,
    generated: true,
  })
  id?: number;

  @property({
    type: 'string',
    required: true,
    index: {
      unique: true,
    },
  })
  quizName: string;

  @property({
    type: 'string',
    required: true,
  })
  accessCode: string;

  @property({
    type: 'date',
  })
  dateCreated?: string;

  @property({
    type: 'number',
    required: true,
  })
  isActive: number;

  @belongsTo(() => Users, {name: 'owner'}, {required: true})
  quizOwner: number;

  constructor(data?: Partial<QuizOwners>) {
    super(data);
  }
}

export interface QuizOwnersRelations {
  // describe navigational properties here
}

export type QuizOwnersWithRelations = QuizOwners & QuizOwnersRelations;
