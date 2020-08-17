import {Entity, model, property, belongsTo} from '@loopback/repository';
import {Users} from './users.model';

@model({
  settings: {
    foreignKeys: {
      'UserMessageHistory-FromUser-FK': {
        name: 'UserMessageHistory-FromUser-FK',
        foreignKey: 'fromUser',
        entityKey: 'id',
        entity: 'Users',
      },
      'UserMessageHistory-ToUser-FK': {
        name: 'UserMessageHistory-ToUser-FK',
        foreignKey: 'toUser',
        entityKey: 'id',
        entity: 'Users',
      },
    },
  },
})
export class UserMessageHistory extends Entity {
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
  message: string;

  @property({
    type: 'date',
    required: true,
  })
  dateSent: string;

  @belongsTo(() => Users, {name: 'sender'}, {required: true})
  fromUser: number;

  @belongsTo(() => Users, {name: 'receiver'}, {required: true})
  toUser: number;

  constructor(data?: Partial<UserMessageHistory>) {
    super(data);
  }
}

export interface UserMessageHistoryRelations {
  // describe navigational properties here
}

export type UserMessageHistoryWithRelations = UserMessageHistory &
  UserMessageHistoryRelations;
